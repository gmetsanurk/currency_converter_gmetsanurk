import Combine
import NetworkManager
import SnapKit
import UIKit

class HomeView: UIViewController {
    var selectedCurrencyLabel = UILabel()
    unowned var convertFromButton: UIButton!
    unowned var convertToButton: UIButton!
    private var currencyAmountTextField = UITextField()
    var convertToButtonSelected: String?
    var convertFromButtonSelected: String?

    private var keyboardWillShowNotificationCancellable: AnyCancellable?
    private var keyboardWillHideNotificationCancellable: AnyCancellable?

    private lazy var network = NetworkManager()

    private lazy var presenter = HomePresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green

        #if USING_DELEGATES
            let buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
                let selectCurrenciesScreen = SelectCurrencyScreen()
                selectCurrenciesScreen.previousScreen = self
                present(selectCurrenciesScreen, animated: true)
            })
        #else
            let buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
                Task { [weak self] in
                    await self?.presenter.handleSelectFromCurrency()
                }
            })
        #endif

        buttonOpenSourceCurrency.setTitle(NSLocalizedString("home_view.select_source_currency", comment: "Select source curency"), for: .normal)
        buttonOpenSourceCurrency.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.selectSourceCurrency
        buttonOpenSourceCurrency.setTitleColor(.white, for: .normal)
        view.addSubview(buttonOpenSourceCurrency)

        buttonOpenSourceCurrency.snp.makeConstraints { make in
            make.top.equalTo(view).inset(100)
            make.centerX.equalTo(view)
        }

        selectedCurrencyLabel.text = "-"
        view.addSubview(selectedCurrencyLabel)

        selectedCurrencyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.centerX.equalTo(view)
        }

        let convertFromButton = createCurrencyButton(
            title: NSLocalizedString("home_view.from", comment: "From button")
        ) {
            Task { [weak self] in
                await self?.presenter.handleSelectFromCurrency()
            }
        }
        convertFromButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.fromButton
        view.addSubview(convertFromButton)
        self.convertFromButton = convertFromButton

        convertFromButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview().multipliedBy(0.65)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        let convertToButton = createCurrencyButton(
            title: NSLocalizedString("home_view.to", comment: "To button")
        ) {
            Task { [weak self] in
                await self?.presenter.handleSelectToCurrency()
            }
        }
        convertToButton.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.toButton
        view.addSubview(convertToButton)
        self.convertToButton = convertToButton

        convertToButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview().multipliedBy(1.35)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }

        addTextField()
        currencyAmountTextField.delegate = self

        let doConvertActionButton = UIButton(type: .system)
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

        doConvertActionButton.backgroundColor = .systemBlue
        doConvertActionButton.setTitleColor(.white, for: .normal)
        doConvertActionButton.layer.cornerRadius = 10

        doConvertActionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(360)
            make.centerX.equalTo(view)
            make.width.equalTo(210)
        }

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
    func addTextField() {
        currencyAmountTextField.accessibilityIdentifier = AccessibilityIdentifiers.HomeView.currencyAmountTextField
        currencyAmountTextField.borderStyle = .roundedRect
        currencyAmountTextField.keyboardType = .numberPad
        currencyAmountTextField.placeholder = NSLocalizedString("home_view.enter_amount", comment: "Enter amount textField sign")
        view.addSubview(currencyAmountTextField)

        currencyAmountTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(310)
            make.centerX.equalTo(view)
            make.width.equalTo(210)
        }

        adDoneButtonOnKeyboard()
    }

    func adDoneButtonOnKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

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
    func createCurrencyButton(title: String, onSelected: (() -> Void)!) -> UIButton {
        let button = UIButton()

        button.addAction(UIAction { _ in
            onSelected()
        }, for: .touchUpInside)

        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
}

extension HomeView: AnyHomeView {
    func present(screen: AnyScreen) {
        if let screenController = screen as? (UIViewController & AnyScreen) {
            presentController(screen: screenController)
        }
    }

    func fromCurrencySelected(currency: CurrencyType?) {
        currencySelected(currency: currency, button: convertFromButton)
    }

    func toCurrencySelected(currency: CurrencyType?) {
        currencySelected(currency: currency, button: convertToButton)
    }

    private func currencySelected(currency: CurrencyType?, button: UIButton) {
        let selectedCurrency = String(currency?.code ?? "")
        button.setTitle(currency?.code, for: .normal)
        selectedCurrencyLabel.text = currency?.fullName
    }

    func conversionCompleted(result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedCurrencyLabel.text = result
        }
    }
}

extension HomeView: URLSessionDelegate, URLSessionTaskDelegate {}
