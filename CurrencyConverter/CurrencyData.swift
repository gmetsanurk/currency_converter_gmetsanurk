import Dispatch
import RealmSwift
import CoreData
import UIKit

class RealmCurrency: Object {
    @Persisted var code: String
    @Persisted var fullName: String
    
    convenience init(code: String, fullName: String) {
        self.init()
        self.code = code
        self.fullName = fullName
    }
}

struct ConvertCurrency: Codable {
    let info: Info
    let query: Query
    let result: Double
    let success: Bool

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

struct Currencies: Codable {
    let currencies: [String: String]
    let success: Bool
}

class CurrenciesProxy {
    //let currencies: [RealmCurrency]
    let currencies: [CoreDataCurrency]
    
    init(currencies: Currencies) {
        self.currencies = currencies.currencies.map {
            .init(code: $0.key, fullName: $0.value, context: CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
    
}

@objc(CoreDataCurrency)
public class CoreDataCurrency: NSManagedObject {

}

extension CoreDataCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCurrency> {
        return NSFetchRequest<CoreDataCurrency>(entityName: "CoreDataCurrency")
    }

    @NSManaged public var code: String?
    @NSManaged public var fullName: String?
    
    convenience init(code: String, fullName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataCurrency", in: context)!
        self.init(entity: entity, insertInto: context)
        self.code = code
        self.fullName = fullName
    }
}

extension CoreDataCurrency : Identifiable {

}
