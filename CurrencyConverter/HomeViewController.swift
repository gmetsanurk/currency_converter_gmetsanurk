import UIKit
import SnapKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green

        let buttonOpenSourceCurrency = UIButton(primaryAction: UIAction { [unowned self] _ in
            let selectCurrencyScreen = SelectCurrencyScreen()
            self.present(selectCurrencyScreen, animated: true)
        })
        buttonOpenSourceCurrency.setTitle("Select source currency", for: .normal)
        buttonOpenSourceCurrency.setTitleColor(.white, for: .normal)
        view.addSubview(buttonOpenSourceCurrency)

        buttonOpenSourceCurrency.snp.makeConstraints { make in
            make.top.equalTo(view).inset(100)
            make.centerX.equalTo(view)
        }
    }
}

class SelectCurrencyScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 100, height: 100)
        let currenciesList = CollectionView<MyCell, String>(frame: .zero, collectionViewLayout: layout)
        currenciesList.data = ["Hello", "world"]
        currenciesList.backgroundColor = .clear
        view.addSubview(currenciesList)
        currenciesList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

protocol CustomizableCell {
    func setup(with: Any)
}

class MyCell: UICollectionViewCell, CustomizableCell {
    private unowned var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .blue
        let someLabel = UILabel()
        contentView.addSubview(someLabel)
        someLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.label = someLabel
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    func setup(with value: Any) {
        label.text = value as? String
    }
}

class CollectionView<CellType: UICollectionViewCell & CustomizableCell, DataType>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var data: [DataType] = [] {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        register(CellType.self, forCellWithReuseIdentifier: "cell")
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell as? CustomizableCell)?.setup(with: data[indexPath.item])
        return cell
    }
}
