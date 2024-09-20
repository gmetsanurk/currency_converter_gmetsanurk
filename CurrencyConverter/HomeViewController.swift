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
