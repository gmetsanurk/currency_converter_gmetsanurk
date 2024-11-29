import CoreData
import Foundation
import NetworkManager
import UIKit

actor CoreDataManager {
    public static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public func logCoreDataDBPath() {
        if let url = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("DataBase URL - \(url)")
        }
    }

    private func fetchCurrencies() -> [CoreDataCurrency] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataCurrency")
        do {
            return (try? context.fetch(fetchRequest) as? [CoreDataCurrency]) ?? []
        }
    }

    func deleteAllCurrencies() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataCurrency")
        do {
            let currencies = try? context.fetch(fetchRequest) as? [CoreDataCurrency]
            currencies?.forEach { context.delete($0) }
        }
    }

    private func coreDataIsEmpty() async -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CoreDataCurrency")
        fetchRequest.fetchLimit = 1
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Check Error")
            return true
        }
    }
}

extension CoreDataManager: LocalDatabase {
    func save(currencies: Currencies) async throws {
        let backgroundContext = context

        backgroundContext.perform { [weak self] in
            guard let self else {
                return
            }
        }
        for (code, fullName) in currencies.currencies {
            let currencyEntity = NSEntityDescription.insertNewObject(
                forEntityName: "CoreDataCurrency",
                into: backgroundContext
            )
            currencyEntity.setValue(code, forKey: "code")
            currencyEntity.setValue(fullName, forKey: "fullName")
        }
        do {
            try backgroundContext.save()
        } catch {
            print("Saving context error")
            backgroundContext.rollback()
        }
    }

    func loadCurrencies() async throws -> Currencies {
        let currencies = fetchCurrencies()

        return Currencies(
            currencies: .init(
                uniqueKeysWithValues: Set(currencies).map {
                    ($0.code ?? "", $0.fullName ?? "")
                }
            ),
            success: true
        )
    }

    func isEmptyCurrencies() async -> Bool {
        await coreDataIsEmpty()
    }
}
