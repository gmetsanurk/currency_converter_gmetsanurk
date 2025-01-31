import Combine
import NetworkManager
import SnapKit
import UIKit

class HomeView: UIViewController {
    private var selectedCurrencyLabel = UILabel()
    private var buttonOpenSourceCurrency: UIButton!
    private var convertFromButton: UIButton!
    private var convertToButton: UIButton!
    private var doConvertActionButton: UIButton!
    private var currencyAmountTextField = UITextField()
    private var convertToButtonSelected: String?
    private var convertFromButtonSelected: String?
    
    private var keyboardWillShowNotificationCancellable: AnyCancellable?
    private var keyboardWillHideNotificationCancellable: AnyCancellable?
    
    private lazy var network = NetworkManager()
    private lazy var presenter = HomePresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.homeViewBackgroundColor
        
#if USING_DELEGATES
        buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
            let selectCurrenciesScreen = SelectCurrencyScreen()
            selectCurrenciesScreen.previousScreen = self
            present(selectCurrenciesScreen, animated: true)
        })
#else
        buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
            Task { [weak self] in
                await self?.presenter.handleSelectFromCurrency()
            }
        })
#endif
        
        createSelectCurrencyLabel()
        createButtonOpenSourceCurrency()
        createConvertFromButton()
        createConvertToButton()
        createTextField()
        createDoConvertActionButton()
        createKeyboard()
    }
    
    /* override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     
     if self.view.backgroundColor == .yellow {
     return
     }
     
     let controller = HomeViewController()
     controller.view.backgroundColor = .yellow
     present(controller, animated: true)
     } */
}

extension HomeView: SelectCurrencyScreenDelegate {
    func onCurrencySelected(currency: String) {
        selectedCurrencyLabel.text = currency
        print("cell text received \(currency)")
    }
}

extension HomeView: UITextFieldDelegate {
    func createTextField() {
        currencyAmountTextField.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.currencyAmountTextField
        currencyAmountTextField.borderStyle = .roundedRect
        currencyAmountTextField.keyboardType = .numberPad
        currencyAmountTextField.placeholder = NSLocalizedString("home_view.enter_amount", comment: "Enter amount textField sign")
        view.addSubview(currencyAmountTextField)
        setupCurrencyAmountTextFieldConstraints()
        createDoneButtonOnKeyboard()
        currencyAmountTextField.delegate = self
    }
    
    func createDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("home_view.done", comment: "Done keyboard button"), style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.keyboardDone
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexSpace, doneButton]
        currencyAmountTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneButtonTapped() {
        currencyAmountTextField.resignFirstResponder()
    }
    
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension HomeView {
    func createSelectCurrencyLabel() {
        selectedCurrencyLabel.text = "-"
        view.addSubview(selectedCurrencyLabel)
        setupSelectCurrencyLabelConstraints()
    }
    
    func createButtonOpenSourceCurrency() {
        buttonOpenSourceCurrency.setTitle(NSLocalizedString("home_view.select_source_currency", comment: "Select source curency"), for: .normal)
        buttonOpenSourceCurrency.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.selectSourceCurrency
        buttonOpenSourceCurrency.setTitleColor(AppColors.homeViewButtonsTextColor, for: .normal)
        buttonOpenSourceCurrency.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium) 
        view.addSubview(buttonOpenSourceCurrency)
        setupButtonOpenSourceCurrencyConstraints()
    }
    
    func createDoConvertActionButton() {
        doConvertActionButton = UIButton(type: .system)
        doConvertActionButton.setTitle(NSLocalizedString("home_view.convert", comment: "Convert button"), for: .normal)
        doConvertActionButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.convertButton
        doConvertActionButton.addAction(UIAction { [unowned self] _ in
            // print("button pressed")
            print("check before .convertCurrency call: \(currencyAmountTextField.text) + \(convertFromButtonSelected) + \(convertToButtonSelected)")
            guard let amountTextString = currencyAmountTextField.text else {
                return
            }
            presenter.convertCurrency(amountText: amountTextString, fromCurrency: convertFromButtonSelected, toCurrency: convertToButtonSelected)
        }, for: .touchUpInside)
        view.addSubview(doConvertActionButton)
        doConvertActionButton.backgroundColor = AppColors.homeViewButtonsBackgroundColor
        doConvertActionButton.setTitleColor(AppColors.homeViewButtonsTextColor, for: .normal)
        doConvertActionButton.layer.cornerRadius = AppGeometry.cornerRadius
        setupDoConvertActionButtonConstraints()
    }
    
    func createCurrencyButton(title: String, onSelected: (() -> Void)!) -> UIButton {
        let button = UIButton()
        
        button.addAction(UIAction { _ in
            onSelected()
        }, for: .touchUpInside)
        
        button.setTitle(title, for: .normal)
        button.backgroundColor = AppColors.homeViewButtonsBackgroundColor
        button.setTitleColor(AppColors.homeViewButtonsTextColor, for: .normal)
        button.layer.cornerRadius = AppGeometry.cornerRadius
        return button
    }
    
    func createConvertFromButton() {
        convertFromButton = createCurrencyButton(
            title: NSLocalizedString("home_view.from", comment: "From button")
        ) {
            Task { [weak self] in
                await self?.presenter.handleSelectFromCurrency()
            }
        }
        convertFromButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.fromButton
        view.addSubview(convertFromButton)
        
        setupConvertFromButtonConstraints()
    }
    
    func createConvertToButton() {
        convertToButton = createCurrencyButton(
            title: NSLocalizedString("home_view.to", comment: "To button")
        ) {
            Task { [weak self] in
                await self?.presenter.handleSelectToCurrency()
            }
        }
        convertToButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.toButton
        view.addSubview(convertToButton)
        setupConvertToButtonConstraints()
    }
    
    func createKeyboard() {
        keyboardWillShowNotificationCancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.view.frame.origin.y = -200
            }
        keyboardWillHideNotificationCancellable = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.view.frame.origin.y = 0.0
            }
    }
    
    func setupSelectCurrencyLabelConstraints() {
        selectedCurrencyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }
    
    func setupButtonOpenSourceCurrencyConstraints() {
        buttonOpenSourceCurrency.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(selectedCurrencyLabel.snp.top).offset(-40)
        }
    }
    
    func setupConvertFromButtonConstraints() {
        convertFromButton.snp.makeConstraints { make in
            make.centerX.equalTo(view).multipliedBy(0.65)
            make.top.equalTo(selectedCurrencyLabel.snp.bottom).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    func setupConvertToButtonConstraints() {
        convertToButton.snp.makeConstraints { make in
            make.centerX.equalTo(view).multipliedBy(1.35)
            make.top.equalTo(selectedCurrencyLabel.snp.bottom).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    func setupCurrencyAmountTextFieldConstraints() {
        currencyAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(selectedCurrencyLabel.snp.bottom).offset(115)
            make.centerX.equalTo(view)
            make.width.equalTo(240)
        }
    }
    
    func setupDoConvertActionButtonConstraints() {
        doConvertActionButton.snp.makeConstraints { make in
            make.top.equalTo(currencyAmountTextField.snp.bottom).offset(25)
            make.centerX.equalTo(view)
            make.width.equalTo(240)
            make.height.equalTo(40)
        }
    }
}

extension HomeView: AnyHomeView {
    func present(screen: AnyScreen) {
        if let screenController = screen as? (UIViewController & AnyScreen) {
            presentController(screen: screenController)
        }
    }
    
    func fromCurrencySelected(currency: CurrencyType?) {
        convertFromButtonSelected = currencySelected(currency: currency, button: convertFromButton)
    }
    
    func toCurrencySelected(currency: CurrencyType?) {
        convertToButtonSelected = currencySelected(currency: currency, button: convertToButton)
    }
    
    private func currencySelected(currency: CurrencyType?, button: UIButton) -> String {
        button.setTitle(currency?.code, for: .normal)
        selectedCurrencyLabel.text = currency?.fullName
        return String(currency?.code ?? "")
    }
    
    func conversionCompleted(result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedCurrencyLabel.text = result
        }
    }
}

extension HomeView: URLSessionDelegate, URLSessionTaskDelegate {}
