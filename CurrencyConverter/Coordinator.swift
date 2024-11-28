import UIKit

protocol Coordinator {
    func openHomeScreen()
    func openCurrenciesSelection(onCurrencySelected: @escaping SelectCurrencyScreenHandler)
}

struct UIKitCoordinator: Coordinator {
    unowned var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func openHomeScreen() {
        window.rootViewController = HomeView()
        window.makeKeyAndVisible()
    }

    func openCurrenciesSelection(onCurrencySelected: @escaping SelectCurrencyScreenHandler) {
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
