//
//  TipCoreDataManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 2.10.2025.
//


//
//  TipCoreDataManager.swift
//  TipCalculator
//

import Foundation
import CoreData
import UIKit

final class TipCoreDataManager {
    static let shared = TipCoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        // --- Model ---
        let model = NSManagedObjectModel()

        // Entity: TipEntity
        let tip = NSEntityDescription()
        tip.name = "TipEntity"
        tip.managedObjectClassName = "TipEntity"

        // Attributes
        func makeAttr(_ name: String, _ type: NSAttributeType, optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        let attrID          = makeAttr("id", .UUIDAttributeType)
        let attrCreatedAt   = makeAttr("createdAt", .dateAttributeType)
        let attrTitle       = makeAttr("title", .stringAttributeType, optional: true)

        let attrBase        = makeAttr("baseAmount", .doubleAttributeType)
        let attrPercent     = makeAttr("percent", .integer64AttributeType)
        let attrTipAmount   = makeAttr("tipAmount", .doubleAttributeType)
        let attrTotalAmount = makeAttr("totalAmount", .doubleAttributeType)
        let attrPeople      = makeAttr("peopleCount", .integer64AttributeType)
        let attrCurrency    = makeAttr("currency", .stringAttributeType)

        tip.properties = [
            attrID, attrCreatedAt, attrTitle,
            attrBase, attrPercent, attrTipAmount, attrTotalAmount,
            attrPeople, attrCurrency
        ]
        model.entities = [tip]

        // --- Container ---
        persistentContainer = NSPersistentContainer(name: "TipCore", managedObjectModel: model)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error { fatalError("💥 CoreData load error: \(error)") }
        }
    }

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        guard context.hasChanges else { return }
        do { try context.save() } catch { print("💥 Save failed: \(error)") }
    }
}

// MARK: - CRUD
extension TipCoreDataManager {
    @discardableResult
    func insertTip(title: String?,
                   baseAmount: Double,
                   percent: Int,
                   tipAmount: Double,
                   totalAmount: Double,
                   peopleCount: Int,
                   currency: String,
                   createdAt: Date = Date()) -> TipModel {

        let e = TipEntity(context: context)
        e.id = UUID()
        e.createdAt = createdAt
        e.title = title
        e.baseAmount = baseAmount
        e.percent = Int64(percent)
        e.tipAmount = tipAmount
        e.totalAmount = totalAmount
        e.peopleCount = Int64(peopleCount)
        e.currency = currency

        saveContext()

        return TipModel(
            id: e.id,
            title: e.title,
            createdAt: createdAt,
            baseAmount: baseAmount,
            percent: percent,
            tipAmount: tipAmount,
            totalAmount: totalAmount,
            peopleCount: peopleCount,
            currency: currency
        )
    }

    func fetchTips() -> [TipModel] {
        let req: NSFetchRequest<TipEntity> = TipEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            return try context.fetch(req).map {
                TipModel(
                    id: $0.id,
                    title: $0.title,
                    createdAt: $0.createdAt,
                    baseAmount: $0.baseAmount,
                    percent: Int($0.percent),
                    tipAmount: $0.tipAmount,
                    totalAmount: $0.totalAmount,
                    peopleCount: Int($0.peopleCount),
                    currency: $0.currency
                )
            }
        } catch {
            print("❌ Fetch tips error: \(error)")
            return []
        }
    }

    func fetchTip(id: UUID) -> TipModel? {
        let req: NSFetchRequest<TipEntity> = TipEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            guard let e = try context.fetch(req).first else { return nil }
            return TipModel(
                id: e.id,
                title: e.title,
                createdAt: e.createdAt,
                baseAmount: e.baseAmount,
                percent: Int(e.percent),
                tipAmount: e.tipAmount,
                totalAmount: e.totalAmount,
                peopleCount: Int(e.peopleCount),
                currency: e.currency
            )
        } catch {
            print("❌ Fetch tip by id error: \(error)")
            return nil
        }
    }

    func updateTitle(id: UUID, title: String?) {
        let req: NSFetchRequest<TipEntity> = TipEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let e = try? context.fetch(req).first {
            e.title = title
            saveContext()
        }
    }

    func deleteTip(id: UUID) {
        let req: NSFetchRequest<TipEntity> = TipEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        if let first = try? context.fetch(req).first {
            context.delete(first)
            saveContext()
        }
    }
}
