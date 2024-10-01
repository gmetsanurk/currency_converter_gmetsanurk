import UIKit
import SnapKit
import RealmSwift

protocol SelectCurrencyScreenDelegate: AnyObject {
    func onCurrencySelected(currency: String)
}

typealias CurrencyType = Currency
typealias SelectCurrencyScreenHandler = (CurrencyType?) -> Void

class SelectCurrencyScreen: UIViewController {
    #if USING_DELEGATES
    weak var previousScreen: SelectCurrencyScreenDelegate?
    #else
    var onCurrencySelected: SelectCurrencyScreenHandler?
    #endif

    private unowned var currenciesList: CollectionView<SelectCurrencyCell, CurrencyType>!
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        
        #if USING_DELEGATES
        let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout, selectDelegate: self)
        #else
        let currenciesList = CollectionView<SelectCurrencyCell, CurrencyType>(frame: .zero, collectionViewLayout: layout, handler: { [unowned self] currency in
            self.onCurrencySelected?(currency as? CurrencyType)
            self.dismiss(animated: true)
        })
        #endif

        currenciesList.backgroundColor = .clear
        view.addSubview(currenciesList)
        self.currenciesList = currenciesList
        currenciesList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            
        let realm = try! Realm()
        if realm.isEmpty {
            networkManager.getCurrencyData { [weak self] currencies in
                guard let currencies else {
                    return
                }

                let data = CurrenciesProxy(currencies: currencies)
                self?.currenciesList.data = data.currencies.map {
                    $0
                }
                let localDatabase = container.resolve(LocalDatabase.self)
                localDatabase?.save(currencies: currencies)
            }
        } else {
            let localDatabase = container.resolve(LocalDatabase.self)
            localDatabase?.loadCurrencies { [weak self] currencies in
                self?.currenciesList.data = currencies.currencies.map {
                    .init(code: $0.key, fullName: $0.value)
                }
            }
        }
    }
}

extension SelectCurrencyScreen: CollectionViewSelectDelegate {
    func onSelected(data: Any) {
        #if USING_DELEGATES
        previousScreen?.onCurrencySelected(currency: data as? String ?? "")
        dismiss(animated: true)
        #else
        onCurrencySelected?(data as? CurrencyType)
        #endif
    }
}
