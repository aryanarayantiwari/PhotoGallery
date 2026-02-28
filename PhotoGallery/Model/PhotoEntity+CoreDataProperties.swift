//
//  PhotoEntity+CoreDataProperties.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//
//

public import Foundation
public import CoreData


public typealias PhotoEntityCoreDataPropertiesSet = NSSet

extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var albumId: Int64
    @NSManaged public var url: String
    @NSManaged public var thumbnailUrl: String
    @NSManaged public var title: String

}

extension PhotoEntity : Identifiable {

}

extension PhotoEntity {
    var galleryImage: GalleryImage {
        GalleryImage(
            id: id,
            albumId: albumId,
            title: title,
            url: url,
            thumbnailUrl: thumbnailUrl
        )
    }
}
