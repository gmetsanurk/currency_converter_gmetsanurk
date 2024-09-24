import UIKit
import SnapKit

protocol SelectCurrencyScreenDelegate: AnyObject {
    func onCurrencySelected(currency: String)
}

typealias SelectCurrencyScreenHandler = (String) -> Void

class SelectCurrencyScreen: UIViewController {
    //weak var previousScreen: SelectCurrencyScreenDelegate?
    var onCurrencySelected: SelectCurrencyScreenHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout, handler: { [unowned self] currency in
            self.onCurrencySelected?(currency as? String ?? "")
            self.dismiss(animated: true)
        })
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
        //previousScreen?.onCurrencySelected(currency: data as? String ?? "")
        onCurrencySelected?(data as? String ?? "")
        dismiss(animated: true)
    }
}
