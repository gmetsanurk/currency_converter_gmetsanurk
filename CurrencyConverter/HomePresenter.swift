import Combine
import NetworkManager
import SnapKit
import UIKit

protocol AnyScreen {
    func present(screen: AnyScreen)
}

extension AnyScreen where Self: UIViewController {
    func presentController(screen: AnyScreen & UIViewController) {
        present(screen, animated: true)
    }
}

protocol AnyHomeView: AnyScreen, AnyObject {
    func currencySelected(currency: CurrencyType?)
    func conversionCompleted(result: String)
}

class HomePresenter {
    unowned var view: AnyHomeView!

    init(view: AnyHomeView) {
        self.view = view
    }

    @MainActor
    func handleSelectSourceCurrency() async {
        let coordinator = await dependencies.resolve(Coordinator.self)
        coordinator?.openCurrenciesScreen(onCurrencySelected: { [weak self] currency in
            self?.view.currencySelected(currency: currency)
            print("cell text received \(String(describing: currency))")
            coordinator?.openHomeScreen()
        })
    }

    func convertCurrency(amountText: String, fromCurrency: String?, toCurrency: String?) {
        guard let amount = Int(amountText),
              let fromCurrency, !fromCurrency.isEmpty,
              let toCurrency, !toCurrency.isEmpty
        else {
            print("Fill all the blanks")
            return
        }

        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                guard let remoteDataSource = await dependencies.resolve(RemoteDataSource.self) else {
                    return
                }
                let result = try await remoteDataSource.convertCurrencyData(to: toCurrency, from: fromCurrency, amount: amount)

                if result.success {
                    let conversionResult = "\(NSLocalizedString("home_view.result", comment: "Convertation result")): \(result.result)"
                    view.conversionCompleted(result: conversionResult)
                } else {
                    print("Cannot complete convertation")
                }
            } catch {}
        }
    }
}
