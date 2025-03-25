protocol AnySelectView: AnyScreen, AnyObject {}

class SelectPresenter {
    unowned var view: AnySelectView

    init(view: AnySelectView) {
        self.view = view
    }

    func callDataBase() async throws -> [CurrencyType] {
        let emptyList: [CurrencyType] = []
        guard let localDatabase = await dependencies.resolve(LocalDatabase.self) else {
            return emptyList
        }
        let isEmptyCurrencies = await localDatabase.isEmptyCurrencies()
        if isEmptyCurrencies {
            guard let manager = await dependencies.resolve(RemoteDataSource.self) else {
                return emptyList
            }

            let currencies = try await manager.getCurrencyData()

            let data = await CurrenciesProxy(currencies: currencies)

            // CoreDataManager.shared.logCoreDataDBPath()
            try await localDatabase.save(currencies: currencies)

            return data.currencies.map {
                $0
            }
        } else {
            let currencies = try await localDatabase.loadCurrencies()
            return await currencies.currencies.asyncMap {
                await .init(
                    code: $0.key,
                    fullName: $0.value
                )
            }
        }
    }
}
