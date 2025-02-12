import UIKit

protocol Coordinator {
    func openHomeScreen()
    func openCurrenciesScreen(onCurrencySelected: @escaping SelectCurrencyScreenHandler)
}


#if USING_OBJC
private typealias HomeViewClass = HomeViewObjCViewController
#elseif !USING_OBJC
private typealias HomeViewClass = HomeView
#endif

struct UIKitCoordinator: Coordinator {
    unowned var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func openHomeScreen() {
        if let someScreen = window.rootViewController, let presentedViewController = someScreen.presentedViewController as? SelectCurrencyScreen {
            presentedViewController.dismiss(animated: true)
        } else {
            window.rootViewController = HomeViewClass()
            window.makeKeyAndVisible()
        }
    }

    func openCurrenciesScreen(onCurrencySelected: @escaping SelectCurrencyScreenHandler) {
        let selectCurrenciesScreen = SelectCurrencyScreen()
        selectCurrenciesScreen.onCurrencySelected = onCurrencySelected
        if let homeView = window.rootViewController as? AnyHomeView {
            homeView.present(screen: selectCurrenciesScreen)
        } else if window.rootViewController == nil {
            window.rootViewController = HomeViewClass()
            window.makeKeyAndVisible()
            (window.rootViewController as? AnyScreen)?.present(screen: selectCurrenciesScreen)
        }
    }
}
