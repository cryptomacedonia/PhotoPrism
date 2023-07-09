//
//  PhotoPrismApp.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 3.7.23.
//

import SwiftUI

@main
struct PhotoPrismApp: App {
    var photoLibrary = PhotoService()
    @Namespace var namespace
    @State  var showDetail: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
               
                GalleryViewThumbs { item in
                    print("item")
                    showDetail = true
                }
                if showDetail {
                    PagerView {
                        showDetail = false
                    }
                }
            }
        }
    }

}

import Photos
struct Photo {
    let thumbnail: UIImage
    let identifier: String
}

func fetchPhotos(from startDate: Date, completion: @escaping ([Photo]) -> Void) {
    var photos: [Photo] = []
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "creationDate > %@", startDate as NSDate)
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    let imageManager = PHImageManager.default()
    let thumbnailSize = CGSize(width: 100, height: 100) // Adjust the size as per your needs
    
    for i in 0..<fetchResult.count {
        let asset = fetchResult.object(at: i)
        
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { (thumbnail, _) in
            if let thumbnailImage = thumbnail {
                let photo = Photo(thumbnail: thumbnailImage, identifier: asset.localIdentifier)
                photos.append(photo)
            }
        }
    }
    
    completion(photos)
}
func retrieveFullImage(with identifier: String, completion: @escaping (UIImage?) -> Void) {
    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
    
    if let asset = fetchResult.firstObject {
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions) { (image, _) in
            completion(image)
        }
    } else {
        completion(nil)
    }
}
