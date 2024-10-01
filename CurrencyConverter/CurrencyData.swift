//
//  CurrencyData.swift
//  CurrentConverterApp
//
//  Created by Georgy on 2024-09-27.
//

import Dispatch
import RealmSwift

class Currency: Object {
    @Persisted var code: String
    @Persisted var fullName: String
    
    convenience init(code: String, fullName: String) {
        self.init()
        self.code = code
        self.fullName = fullName
    }
}

struct Currencies: Codable {
    let currencies: [String: String]
    let success: Bool
}

class CurrenciesProxy {
    let currencies: [Currency]
    
    init(currencies: Currencies) {
        self.currencies = currencies.currencies.map {
            .init(code: $0.key, fullName: $0.value)
        }
    }
    
    func saveToRealm() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let realm = try! Realm()
            try! realm.write {
                realm.add(self.currencies)
            }
        }
    }
}

class CurrenciesDataBase {
    func getDataFromRealm() -> Results<Currency> {
        let realm = try! Realm()
        let resultsArray: Results<Currency> = realm.objects(Currency.self)
        return resultsArray
    }
}
