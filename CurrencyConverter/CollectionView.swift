import UIKit
import SnapKit

protocol CollectionViewSelectDelegate: AnyObject {
    func onSelected(data: Any)
}

typealias CollectionViewSelectHandler = (Any) -> Void

class CollectionView<CellType: UICollectionViewCell & CustomizableCell, DataType>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    // private weak var selectDelegate: CollectionViewSelectDelegate?
    private var handler: CollectionViewSelectHandler?

    var data: [DataType] = [] {
        didSet {
            reloadData()
        }
    }

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, handler: CollectionViewSelectHandler?) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.handler = handler

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedText = data[indexPath.item]

        handler?(selectedText)
        // selectDelegate?.onSelected(data: selectedText)
    }
}
