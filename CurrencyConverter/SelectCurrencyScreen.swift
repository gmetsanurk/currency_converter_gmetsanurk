import UIKit
import SnapKit

protocol SelectCurrencyScreenDelegate: AnyObject {
    func onCurrencySelected(currency: String)
}

typealias SelectCurrencyScreenHandler = (String) -> Void

class SelectCurrencyScreen: UIViewController {
    #if USING_DELEGATES
    weak var previousScreen: SelectCurrencyScreenDelegate?
    #else
    var onCurrencySelected: SelectCurrencyScreenHandler?
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        
        #if USING_DELEGATES
        let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout, selectDelegate: self)
        #else
        let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout, handler: { [unowned self] currency in
            self.onCurrencySelected?(currency as? String ?? "")
            self.dismiss(animated: true)
        })
        #endif
        
        currenciesList.data = ["RUB", "KZT", "MNT", "KGS"]
        currenciesList.backgroundColor = .clear
        view.addSubview(currenciesList)
        currenciesList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SelectCurrencyScreen: CollectionViewSelectDelegate {
    func onSelected(data: Any) {
        #if USING_DELEGATES
        previousScreen?.onCurrencySelected(currency: data as? String ?? "")
        dismiss(animated: true)
        #else
        onCurrencySelected?(data as? String ?? "")
        #endif
    }
}
