//
// © 2024 Test weather-app
//

import Foundation
import CoreData
import Combine

final class Database {
    var saveNotificationPublisher: AnyPublisher<Notification, Never> {
        return persistentContainer.viewContext.didSavePublisher
    }

    private lazy var persistentContainer = {
        let container = NSPersistentContainer(name: "weather_app")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func saveCity(_ city: City) {
        let context = persistentContainer.viewContext

        let request = CityEntity.fetchRequest()
        let sameID = NSPredicate(format: "id == %@", city.id)
        request.predicate = sameID

        let objects = try? context.fetch(request)

        if objects?.contains(where: { $0.id == city.id }) == true {
            return
        }
        _ = city.entity(in: context)
        saveContext(context)
    }

    func getCity(with id: City.ID) -> City? {
        let context = persistentContainer.viewContext

        let request = CityEntity.fetchRequest()
        let sameID = NSPredicate(format: "id == %@", id)
        request.predicate = sameID

        let objects = try? context.fetch(request)
        return objects?.first?.model
    }

    func getCities() -> [City] {
        let context = persistentContainer.viewContext
        let request = CityEntity.fetchRequest()
        let objects = try? context.fetch(request)

        return objects?.map { $0.model } ?? []
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                context.rollback()
                print(error.localizedDescription)
            }
        }
    }
}

private extension City {
    func entity(in context: NSManagedObjectContext) -> CityEntity {
        let entity = CityEntity(context: context)

        entity.id = id
        entity.localizedName = localizedName
        entity.rank = Int64(rank)
        entity.area = area.entity(in: context)
        entity.country = country.entity(in: context)

        return entity
    }
}

private extension Area {
    func entity(in context: NSManagedObjectContext) -> AreaEntity {
        let entity = AreaEntity(context: context)
        entity.id = id
        entity.localizedName = localizedName

        return entity
    }
}

private extension CityEntity {
    var model: City {
        return .init(
            id: self.id!,
            rank: Int(self.rank),
            localizedName: self.localizedName!,
            country: country!.model,
            area: area!.model
        )
    }
}

private extension AreaEntity {
    var model: Area {
        return .init(
            id: self.id!,
            localizedName: self.localizedName!
        )
    }
}

extension NSManagedObjectContext {
    var didSavePublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave, object: self)
            .eraseToAnyPublisher()
    }
}
