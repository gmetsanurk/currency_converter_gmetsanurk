public struct Currencies: Codable, Sendable {
    public let currencies: [String: String]
    public let success: Bool

    public init(currencies: [String : String], success: Bool) {
        self.currencies = currencies
        self.success = success
    }
}

public struct ConvertCurrency: Codable {
    let info: Info
    let query: Query
    public let result: Double
    public let success: Bool

    struct Info: Codable {
        let quote: Double
        let timestamp: Int
    }

    struct Query: Codable {
        let amount: Double
        let from: String
        let to: String
    }
}
