import Dispatch
import RealmSwift
import CoreData
import UIKit
import NetworkManager

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
public class CoreDataCurrency: NSManagedObject {

}

extension CoreDataCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataCurrency> {
        return NSFetchRequest<CoreDataCurrency>(entityName: "CoreDataCurrency")
    }

    @NSManaged public var code: String?
    @NSManaged public var fullName: String?
    
    convenience init(code: String, fullName: String) async {
        let context = await CoreDataManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CoreDataCurrency", in: context)!
        self.init(entity: entity, insertInto: context)
        self.code = code
        self.fullName = fullName
    }
}

extension CoreDataCurrency : Identifiable {

}
