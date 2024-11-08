import UIKit
import Combine
import SnapKit
import NetworkManager

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

        Task { [weak self] in
            guard let localDatabase = await dependencies.resolve(LocalDatabase.self) else {
                return
            }
            let isEmptyCurrencies = await localDatabase.isEmptyCurrencies()
            if isEmptyCurrencies {
                do {
                    guard let self = self else {
                        return
                    }
                    
                    guard let manager = await dependencies.resolve(RemoteDataSource.self) else {
                        return
                    }
                    
                    let currencies = try await manager.getCurrencyData()
                    
                    let data = await CurrenciesProxy(currencies: currencies)
                    self.currenciesList.data = data.currencies.map {
                        $0
                    }
                    // CoreDataManager.shared.logCoreDataDBPath()
                    try await localDatabase.save(currencies: currencies)
                } catch {
                    print("Error: \(error)")
                }
            } else {
                do {
                    let currencies = try await localDatabase.loadCurrencies()
                    self?.currenciesList.data = await currencies.currencies.asyncMap {
                        await .init(
                            code: $0.key,
                            fullName: $0.value
                        )
                    }
                } catch {
                    print("Error fetching or saving currencies: \(error)")
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

extension SelectCurrencyScreen: AnyScreen {
    func present(screen: any AnyScreen) {
        
    }
}
