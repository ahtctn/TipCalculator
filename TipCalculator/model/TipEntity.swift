//
//  TipEntity.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 2.10.2025.
//


//
//  TipEntity.swift
//

import Foundation
import CoreData

@objc(TipEntity)
public class TipEntity: NSManagedObject {}

extension TipEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TipEntity> {
        NSFetchRequest<TipEntity>(entityName: "TipEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var title: String?
    @NSManaged public var baseAmount: Double
    @NSManaged public var percent: Int64
    @NSManaged public var tipAmount: Double
    @NSManaged public var totalAmount: Double
    @NSManaged public var peopleCount: Int64
    @NSManaged public var currency: String
}

extension TipEntity: Identifiable {}
