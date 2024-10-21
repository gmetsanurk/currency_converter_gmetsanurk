import UIKit
import SnapKit

protocol CustomizableCell {
    func setup(with: Any)
}

class SelectCurrencyCell: UICollectionViewCell, @preconcurrency CustomizableCell {
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
        label.text = (value as? CurrencyType)?.code
    }
}
