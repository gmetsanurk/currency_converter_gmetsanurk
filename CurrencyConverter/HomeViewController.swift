import Combine
import UIKit
import SnapKit
import NetworkManager

class HomeViewController: UIViewController {
    private var selectedCurrencyLabel = UILabel()
    private var currencyAmountTextField = UITextField()
    var convertToButtonSelected: String?
    var convertFromButtonSelected: String?

    private var keyboardWillShowNotificationCancellable: AnyCancellable?
    private var keyboardWillHideNotificationCancellable: AnyCancellable?

    private let network = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        
#if USING_DELEGATES
        let buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
            let selectCurrenciesScreen = SelectCurrencyScreen()
            selectCurrenciesScreen.previousScreen = self
            self.present(selectCurrenciesScreen, animated: true)
        })
#else
        let buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
            let selectCurrenciesScreen = SelectCurrencyScreen()
            selectCurrenciesScreen.onCurrencySelected = { [weak self] currency in
                self?.selectedCurrencyLabel.text = currency?.fullName
                print("cell text received \(String(describing: currency))")
            }
            self.present(selectCurrenciesScreen, animated: true)
        })
#endif
        
        buttonOpenSourceCurrency.setTitle(NSLocalizedString("home_view.select_source_currency", comment: "Select source curency"), for: .normal)
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
        
        
        let convertFromButton = createCurrencyButton(title: NSLocalizedString("home_view.from", comment: "From button"))
        convertFromButton.tag = 1
        view.addSubview(convertFromButton)
        
        convertFromButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview().multipliedBy(0.65)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        
        let convertToButton = createCurrencyButton(title: NSLocalizedString("home_view.to", comment: "To button"))
        convertToButton.tag = 2
        view.addSubview(convertToButton)
        
        convertToButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview().multipliedBy(1.35)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        
        self.addTextField()
        currencyAmountTextField.delegate = self
        
        
        let doConvertActionButton = UIButton(type: .system)
        doConvertActionButton.setTitle(NSLocalizedString("home_view.convert", comment: "Convert button"), for: .normal)
        doConvertActionButton.addAction(UIAction { [unowned self] _ in
            //print("button pressed")
            self.convertCurrency()
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

    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.view.backgroundColor == .yellow {
            return
        }

        let controller = HomeViewController()
        controller.view.backgroundColor = .yellow
        present(controller, animated: true)
    }*/
}

extension HomeViewController {
    func createCurrencyButton(title: String) -> UIButton {
        let button = UIButton()
        
        button.addAction(UIAction { [unowned self, weak button] _ in
            let selectCurrenciesScreen = SelectCurrencyScreen()
            selectCurrenciesScreen.onCurrencySelected = { [unowned self, weak button] currency in
                button?.setTitle(currency?.code, for: .normal)
                print("Currency selected: \(String(describing: currency?.fullName))")
                let selectedCurrency = String(currency?.code ?? "")
                switch button?.tag {
                case 1:
                    self.convertFromButtonSelected = selectedCurrency
                case 2:
                    self.convertToButtonSelected = selectedCurrency
                default:
                    return
                }
            }
            self.present(selectCurrenciesScreen, animated: true)
        }, for: .touchUpInside)
        
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }
    
    func convertCurrency() {
        guard let amountText = currencyAmountTextField.text, let amount = Int(amountText),
              let fromCurrency = convertFromButtonSelected, !fromCurrency.isEmpty,
              let toCurrency = convertToButtonSelected, !toCurrency.isEmpty else {
            print("Fill all the blanks")
            return
        }

        Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            do {
                let result = try await network.convertCurrencyData(to: toCurrency, from: fromCurrency, amount: amount)

                if result.success {
                    //print("Convert Summ: \(result.result)")
                    DispatchQueue.main.async { [weak self] in
                        self?.selectedCurrencyLabel.text = "\(NSLocalizedString("home_view.result", comment: "Convertation result")): \(result.result)"
                    }
                } else {
                    print("Cannot complete convertation")
                }
            } catch {

            }
        }
    }
}

extension HomeViewController: SelectCurrencyScreenDelegate {
    func onCurrencySelected(currency: String) {
        selectedCurrencyLabel.text = currency
        print("cell text received \(currency)")
    }
}

extension HomeViewController: UITextFieldDelegate {
    func addTextField() {
        
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
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexSpace, doneButton]
        currencyAmountTextField.inputAccessoryView = toolBar
    }
    
    @objc private func doneButtonTapped() {
        currencyAmountTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
