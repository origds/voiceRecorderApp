//
//  Voicenote+CoreDataClass.swift
//  
//
//  Created by Oriana Gomez on 23/06/2020.
//
//

import Foundation
import CoreData

@objc(Voicenote)
public class Voicenote: NSManagedObject {

    convenience init(name: String, filePath: String, context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "Voicenote", in: context)!
        self.init(entity: entity, insertInto: context)
        self.name = name
        self.filePath = filePath
        
        do {
            try context.save()
            print("Saved")
        } catch
        {
            print("Saving error")
        }
    }
    
    public func rename(newName: String, context: NSManagedObjectContext!)
    {
        self.name = newName
        do {
            try context.save()
            print("Renamed")
        } catch
        {
            print("Rename error")
        }
    }
}
