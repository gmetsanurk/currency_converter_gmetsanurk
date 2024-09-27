//
//  CurrencyData.swift
//  CurrentConverterApp
//
//  Created by Georgy on 2024-09-27.
//

struct Currency {
    let code: String
    let fullName: String
}

struct Currencies: Codable {
    let currencies: [String: String]
    let success: Bool
}

struct CurrenciesProxy {
    let currencies: [Currency]

    init(currencies: Currencies) {
        self.currencies = currencies.currencies.map {
            .init(code: $0.key, fullName: $0.value)
        }
    }
}
