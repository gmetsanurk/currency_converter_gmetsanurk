import Combine
import NetworkManager
import SnapKit
import UIKit

protocol SelectCurrencyScreenDelegate: AnyObject {
    func onCurrencySelected(currency: String)
}

// typealias CurrencyType = RealmCurrency
typealias CurrencyType = CoreDataCurrency
typealias SelectCurrencyScreenHandler = (CurrencyType?) -> Void

class SelectCurrencyScreen: UIViewController, AnySelectView {
    #if USING_DELEGATES
        weak var previousScreen: SelectCurrencyScreenDelegate?
    #else
        var onCurrencySelected: SelectCurrencyScreenHandler?
    #endif

    private unowned var currenciesList: CollectionView<SelectCurrencyCell, CurrencyType>!
    private lazy var presenter = SelectPresenter(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)

        #if USING_DELEGATES
            let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout, selectDelegate: self)
        #else
            let currenciesList = CollectionView<SelectCurrencyCell, CurrencyType>(frame: .zero, collectionViewLayout: layout, handler: { [unowned self] currency in
                onCurrencySelected?(currency as? CurrencyType)
            })
        #endif

        currenciesList.backgroundColor = .clear
        view.addSubview(currenciesList)
        self.currenciesList = currenciesList
        currenciesList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        Task {
            do {
                try self.currenciesList.data = await presenter.callDataBase()
            } catch {
                print("Error: \(error)")
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

extension SelectCurrencyScreen: SelectCurrencyScreenDelegate {
    func onCurrencySelected(currency _: String) {}
}

extension SelectCurrencyScreen: AnyScreen {
    func present(screen _: any AnyScreen) {}
}
