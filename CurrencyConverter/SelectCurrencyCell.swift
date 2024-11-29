import SnapKit
import UIKit

protocol CustomizableCell {
    func setup(with: Any)
}

class SelectCurrencyCell: UICollectionViewCell, CustomizableCell {
    private unowned var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .blue
        let someLabel = UILabel()
        contentView.addSubview(someLabel)
        someLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label = someLabel
    }

    required init?(coder _: NSCoder) {
        nil
    }

    func setup(with value: Any) {
        label.text = (value as? CurrencyType)?.code
    }
}
