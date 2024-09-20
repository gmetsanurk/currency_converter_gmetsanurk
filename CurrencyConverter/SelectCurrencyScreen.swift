import UIKit
import SnapKit

class SelectCurrencyScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        let currenciesList = CollectionView<SelectCurrencyCell, String>(frame: .zero, collectionViewLayout: layout)
        currenciesList.data = ["Hello", "world"]
        currenciesList.backgroundColor = .clear
        view.addSubview(currenciesList)
        currenciesList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
