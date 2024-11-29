import SnapKit
import UIKit

protocol CollectionViewSelectDelegate: AnyObject {
    func onSelected(data: Any)
}

typealias CollectionViewSelectHandler = (Any) -> Void

class CollectionView<CellType: UICollectionViewCell & CustomizableCell, DataType>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    var data: [DataType] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
    }

    #if USING_DELEGATES
        private weak var selectDelegate: CollectionViewSelectDelegate?
        init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, selectDelegate: CollectionViewSelectDelegate?) {
            super.init(frame: frame, collectionViewLayout: layout)
            self.selectDelegate = selectDelegate

            register(CellType.self, forCellWithReuseIdentifier: "cell")
            dataSource = self
            delegate = self
        }
    #else
        private var handler: CollectionViewSelectHandler?
        init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, handler: CollectionViewSelectHandler?) {
            super.init(frame: frame, collectionViewLayout: layout)
            self.handler = handler

            register(CellType.self, forCellWithReuseIdentifier: "cell")
            dataSource = self
            delegate = self
        }
    #endif

    required init?(coder _: NSCoder) {
        nil
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        (cell as? CustomizableCell)?.setup(with: data[indexPath.item])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedText = data[indexPath.item]
        #if USING_DELEGATES
            selectDelegate?.onSelected(data: selectedText)
        #else
            handler?(selectedText)
        #endif
    }
}
