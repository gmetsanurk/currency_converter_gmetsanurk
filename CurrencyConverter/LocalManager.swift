import NetworkManager

actor LocalManager: RemoteDataSource {
    
    private let someCurrencies = Currencies(currencies: ["EUR": "Euro", "USD": "United States Dollar", "GBP": "British Pound Sterling", "CNH": "Chinese Yuan Offshore", "RUB": "Russian Ruble", "KZT": "Kazakhstani Tenge", "KGS": "Kyrgystani Som"], success: true)
    
    
    func getCurrencyData() async throws -> Currencies {
        return someCurrencies
    }
    
    
    func convertCurrencyData(to: String, from: String, amount: Int) async throws -> ConvertCurrency {
        switch (from, to) {
        case ("EUR", "RUB"):
            return generateSomeConvertCurrencyExample(amount: amount, multiplier: 100)
        case ("RUB", "EUR"):
            return generateSomeConvertCurrencyExample(amount: amount, multiplier: 0.01)
        default:
            return generateSomeConvertCurrencyExample(amount: amount, multiplier: 1)
        }
    }
    
    func generateSomeConvertCurrencyExample(amount: Int, multiplier: Double) -> ConvertCurrency {
        let info = ConvertCurrency.Info(quote: 0.76953, timestamp: 1729523705)
        let query = ConvertCurrency.Query(amount: 5, from: "FROM", to: "TO")
        
        let result: Double = Double(amount) * multiplier
        
        return ConvertCurrency(info: info, query: query, result: result, success: true)
    }
}
