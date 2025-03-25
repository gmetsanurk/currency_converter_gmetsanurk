import CoreData
import Dispatch
import NetworkManager
import RealmSwift
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

class CurrenciesProxy {
    let currencies: [CoreDataCurrency]

    init(currencies: Currencies) async {
        self.currencies = await currencies.currencies.asyncMap {
            await .init(code: $0.key, fullName: $0.value)
        }
    }
}

@objc(CoreDataCurrency)
public class CoreDataCurrency: NSManagedObject {}

public extension CoreDataCurrency {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CoreDataCurrency> {
        NSFetchRequest<CoreDataCurrency>(entityName: "CoreDataCurrency")
    }

    @NSManaged var code: String?
    @NSManaged var fullName: String?

    internal convenience init(code: String, fullName: String) async {
        let context = await CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataCurrency", in: context)!
        self.init(entity: entity, insertInto: context)
        self.code = code
        self.fullName = fullName
    }
}

extension CoreDataCurrency: Identifiable {}
