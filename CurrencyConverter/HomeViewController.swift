import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private var selectedCurrencyLabel = UILabel()

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
                print("cell text received \(currency)")
            }
            self.present(selectCurrenciesScreen, animated: true)
        })
        #endif
        
        buttonOpenSourceCurrency.setTitle("Select source currency", for: .normal)
        buttonOpenSourceCurrency.setTitleColor(.white, for: .normal)
        view.addSubview(buttonOpenSourceCurrency)

        buttonOpenSourceCurrency.snp.makeConstraints { make in
            make.top.equalTo(view).inset(100)
            make.centerX.equalTo(view)
        }
        
        
        selectedCurrencyLabel.text = "-"
        view.addSubview(selectedCurrencyLabel)
        
        selectedCurrencyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(300)
            make.centerX.equalTo(view)
        }
        
        
        let buttonOpenRealmTestScreen = UIButton(primaryAction: UIAction { [unowned self] _ in
            let realmTestScreen = RealmTestScreen()
            self.present(realmTestScreen, animated: true)
            realmTestScreen.dismiss(animated: true)
        })
        
        buttonOpenRealmTestScreen.setTitle("Open Swift realm Test", for: .normal)
        buttonOpenRealmTestScreen.setTitleColor(.white, for: .normal)
        view.addSubview(buttonOpenRealmTestScreen)
        
        buttonOpenRealmTestScreen.snp.makeConstraints { make in
            make.bottom.equalTo(view).inset(50)
            make.centerX.equalTo(view)
        }
    }
}

extension HomeViewController: SelectCurrencyScreenDelegate {
    func onCurrencySelected(currency: String) {
        selectedCurrencyLabel.text = currency
        print("cell text received \(currency)")
    }
}
