//
//  Collage+CoreDataProperties.swift
//  CollageCreation
//
//  Created by David on 2020/12/16.
//  Copyright © 2020 David. All rights reserved.
//
//

import Foundation
import CoreData


extension Collage {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Collage> {
    return NSFetchRequest<Collage>(entityName: "Collage")
  }
  
  @NSManaged public var creationDate: Date?
  @NSManaged public var id: String?
  @NSManaged public var imageData: Data?
  @NSManaged public var imageRect: String?
}
