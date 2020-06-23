//
//  Voicenote+CoreDataProperties.swift
//  
//
//  Created by Oriana Gomez on 23/06/2020.
//
//

import Foundation
import CoreData


extension Voicenote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Voicenote> {
        return NSFetchRequest<Voicenote>(entityName: "Voicenote")
    }

    @NSManaged public var name: String?
    @NSManaged public var filePath: String?
}
