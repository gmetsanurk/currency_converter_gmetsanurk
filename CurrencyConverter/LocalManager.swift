actor LocalManager: RemoteDataSource {
    private let someCurrencies = Currencies(currencies: ["EUR": "Euro", "USD": "United States Dollar", "GBP": "British Pound Sterling", "CNH": "Chinese Yuan Offshore", "RUB": "Russian Ruble", "KZT": "Kazakhstani Tenge", "KGS": "Kyrgystani Som"], success: true)
    
    func getCurrencyData() async throws -> Currencies {
        return someCurrencies
    }
}
