import Combine
import SwiftUI

class HomeViewSwiftUIController: UIHostingController<HomeViewSwiftUI> {
    lazy var presenter = HomePresenter(view: self)
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.viewModel.$inputButtonPressed.sink { [weak self] _ in
            Task { [weak self] in
                await self?.presenter.handleSelectSourceCurrency()
            }
        }.store(in: &cancellables)
    }
}

class HomeViewViewModel: ObservableObject {
    @Published var inputButtonPressed: Bool
    @Published var selectedCurrency: String

    init(inputButtonPressed: Bool = false, selectedCurrency: String = "Select") {
        self.inputButtonPressed = inputButtonPressed
        self.selectedCurrency = selectedCurrency
    }
}

struct HomeViewSwiftUI: View {
    var viewModel = HomeViewViewModel()

    var body: some View {
        VStack {
            Text(viewModel.selectedCurrency)
            Button("Input") {
                viewModel.inputButtonPressed = true
            }
            Button("Output") {}
        }
    }
}

extension HomeViewSwiftUIController: AnyHomeView {
    func fromCurrencySelected(currency _: CurrencyType?) {}

    func toCurrencySelected(currency _: CurrencyType?) {}

    func present(screen: any AnyScreen) {
        if let screen = screen as? UIViewController {
            present(screen, animated: true)
        }
    }

    func currencySelected(currency: CurrencyType?) {
        rootView.viewModel = .init(selectedCurrency: currency?.code ?? "Unknown")
    }

    func conversionCompleted(result _: String) {}
}
