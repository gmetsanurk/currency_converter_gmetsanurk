import UIKit

protocol Coordinator {
    func openHomeScreen()
    func openCurrenciesScreen(onCurrencySelected: @escaping SelectCurrencyScreenHandler)
}

struct UIKitCoordinator: Coordinator {
    unowned var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func openHomeScreen() {
        if let selectCurrencyScreen = window.rootViewController as? SelectCurrencyScreen {
            selectCurrencyScreen.dismiss(animated: true)
        } else {
            window.rootViewController = HomeView()
            window.makeKeyAndVisible()
        }
    }

    func openCurrenciesScreen(onCurrencySelected: @escaping SelectCurrencyScreenHandler) {
        let selectCurrenciesScreen = SelectCurrencyScreen()
        selectCurrenciesScreen.onCurrencySelected = onCurrencySelected
        if let homeView = window.rootViewController as? HomeView {
            homeView.present(screen: selectCurrenciesScreen)
        } else if window.rootViewController == nil {
            window.rootViewController = HomeView()
            window.makeKeyAndVisible()
        }
    }
}
