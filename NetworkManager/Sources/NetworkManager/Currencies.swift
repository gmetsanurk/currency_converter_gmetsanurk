public struct Currencies: Codable, Sendable {
    public let currencies: [String: String]
    public let success: Bool

    public init(currencies: [String : String], success: Bool) {
        self.currencies = currencies
        self.success = success
    }
}

public struct ConvertCurrency: Codable {
    public let info: Info
    public let query: Query
    public let result: Double
    public let success: Bool

    public struct Info: Codable {
        let quote: Double
        let timestamp: Int
        
        public init(quote: Double, timestamp: Int) {
            self.quote = quote
            self.timestamp = timestamp
        }
    }

    public struct Query: Codable {
        let amount: Double
        let from: String
        let to: String
        
        public init(amount: Double, from: String, to: String) {
            self.amount = amount
            self.from = from
            self.to = to
        }
    }
    
    public init(info: Info, query: Query, result: Double, success: Bool) {
        self.info = info
        self.query = query
        self.result = result
        self.success = success
    }
}
