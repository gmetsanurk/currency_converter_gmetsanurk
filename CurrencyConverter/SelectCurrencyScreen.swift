import UIKit
import SnapKit

protocol SelectCurrencyScreenDelegate: AnyObject {
    func onCurrencySelected(currency: String)
}

//typealias CurrencyType = RealmCurrency
typealias CurrencyType = CoreDataCurrency
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

        guard let localDatabase = container.resolve(LocalDatabase.self) else {
            return
        }

        if localDatabase.isEmptyCurrencies {
            Task { [weak self] in
                do {
                    guard let self else {
                        return
                    }

                    let currencies = try await networkManager.getCurrencyData()

                    let data = CurrenciesProxy(currencies: currencies)
                    self.currenciesList.data = data.currencies.map {
                        $0
                    }
                    // CoreDataManager.shared.logCoreDataDBPath()
                    localDatabase.save(currencies: currencies)
                } catch {

                }
            }
        } else {
            localDatabase.loadCurrencies { [weak self] currencies in
                self?.currenciesList.data = currencies.currencies.map {
                    .init(code: $0.key, fullName: $0.value, context: CoreDataManager.shared.persistentContainer.viewContext)
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
