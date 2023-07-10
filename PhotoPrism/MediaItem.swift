//
//  MediaItem.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 5.7.23.
//

import Foundation
import Alamofire
struct MediaItem: Codable, Identifiable, Hashable {
//    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
//           return lhs.uid == rhs.uid
//       }
    let id: String = UUID().uuidString
    let uid: String?
    let type: String?
    let typeSrc: String?
    let takenAt: String?
    let takenAtLocal: String?
    let takenSrc: String?
    let timeZone: String?
    let path: String?
    let name: String?
    let originalName: String?
    let title: String?
    let description: String?
    let year: Int?
    let month: Int?
    let day: Int?
    let country: String?
    let stack: Int?
    let favorite: Bool?
    let mediaItemPrivate: Bool?
    let iso: Int?
    let focalLength: Int?
    let fNumber: Double?
    let exposure: String?
    let quality: Int?
    let resolution: Int?
    let color: Int?
    let scan: Bool?
    let panorama: Bool?
    let cameraID: Int?
    let cameraModel: String?
    let lensID: Int?
    let lensModel: String?
    let lat: Double?
    let lng: Double?
    let cellID: String?
    let placeID: String?
    let placeSrc: String?
    let placeLabel: String?
    let placeCity: String?
    let placeState: String?
    let placeCountry: String?
    let instanceID: String?
    let fileUID: String?
    let fileRoot: String?
    let fileName: String?
    let hash: String?
    let width: CGFloat?
    let height: CGFloat?
    let portrait: Bool?
    let merged: Bool?
    let createdAt: String?
    let updatedAt: String?
    let editedAt: String?
    let checkedAt: String?
    let deletedAt: String?
    let files: [File]?
    let cameraSrc: String?
    let cameraMake: String?
    let altitude: Int?
    let lensMake: String?
    let documentID: String?
    let cameraSerial: String?
    let cellAccuracy: Int?
    let faces: Int?
    let cornerRadius: CGFloat = 5.0
    var selected: Bool = false
    var liked: Bool = false
    var showTitle: Bool = false
    enum CodingKeys: String, CodingKey, Equatable {
        case id = "ID"
        case uid = "UID"
        case type = "Type"
        case typeSrc = "TypeSrc"
        case takenAt = "TakenAt"
        case takenAtLocal = "TakenAtLocal"
        case takenSrc = "TakenSrc"
        case timeZone = "TimeZone"
        case path = "Path"
        case name = "Name"
        case originalName = "OriginalName"
        case title = "Title"
        case description = "Description"
        case year = "Year"
        case month = "Month"
        case day = "Day"
        case country = "Country"
        case stack = "Stack"
        case favorite = "Favorite"
        case mediaItemPrivate = "Private"
        case iso = "Iso"
        case focalLength = "FocalLength"
        case fNumber = "FNumber"
        case exposure = "Exposure"
        case quality = "Quality"
        case resolution = "Resolution"
        case color = "Color"
        case scan = "Scan"
        case panorama = "Panorama"
        case cameraID = "CameraID"
        case cameraModel = "CameraModel"
        case lensID = "LensID"
        case lensModel = "LensModel"
        case lat = "Lat"
        case lng = "Lng"
        case cellID = "CellID"
        case placeID = "PlaceID"
        case placeSrc = "PlaceSrc"
        case placeLabel = "PlaceLabel"
        case placeCity = "PlaceCity"
        case placeState = "PlaceState"
        case placeCountry = "PlaceCountry"
        case instanceID = "InstanceID"
        case fileUID = "FileUID"
        case fileRoot = "FileRoot"
        case fileName = "FileName"
        case hash = "Hash"
        case width = "Width"
        case height = "Height"
        case portrait = "Portrait"
        case merged = "Merged"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case editedAt = "EditedAt"
        case checkedAt = "CheckedAt"
        case deletedAt = "DeletedAt"
        case files = "Files"
        case cameraSrc = "CameraSrc"
        case cameraMake = "CameraMake"
        case altitude = "Altitude"
        case lensMake = "LensMake"
        case documentID = "DocumentID"
        case cameraSerial = "CameraSerial"
        case cellAccuracy = "CellAccuracy"
        case faces = "Faces"
    }
    static func sampleItems(count: Int = 100)->[MediaItem] {
//        print(gallerySampleData.utf8)
        return Array((try! JSONDecoder().decode([MediaItem].self, from: Data(gallerySampleData.utf8))).prefix(count))
    }
    static func getImagesFromPhotoPrismTest(completion:@escaping ([MediaItem])->()) {
      
            AF.request("\(apiUrl)/api/v1/photos?count=120", method: .get, parameters: nil, encoding:URLEncoding.default, headers: nil, interceptor: nil)
    //        AF.request("https://demo.photoprism.app/api/v1/photos?count=120&offset=0&merged=true&country=&camera=0&lens=0&label=&year=0&month=0&color=&order=newest&q=\(searchText)&public=true&quality=3", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
                .response { resp in
                    switch resp.result {
                    case let .success(data):
                        do {
                            let jsonData = try JSONDecoder().decode([MediaItem].self, from: data!)
                            print(jsonData)
                            completion(jsonData)
                        } catch {
                            print(error.localizedDescription)
                            completion([])
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                        completion([])
                    }
                }
        }
   // https://photoprism.celliqa.com/api/v1/photos?count=120
    
}

// MARK: - File
struct File: Codable, Equatable, Hashable {
    let uid: String?
    let photoUID: String?
    let name: String?
    let root: String?
    let hash: String?
    let size: Int?
    let primary: Bool?
    let codec: String?
    let fileType: String?
    let mediaType: String?
    let mime: String?
    let width: Int?
    let height: Int?
    let orientation: Int?
    let aspectRatio: Double?
    let colors: String?
    let luminance: String?
    let diff: Int?
    let chroma: Int?
    let createdAt: String?
    let updatedAt: String?
    let markers: [Marker]?
    let duration: Int?
    let fps: Double?
    let frames: Int?
    let portrait: Bool?
    let video: Bool?
    let instanceID: String?

    enum CodingKeys: String, CodingKey {
        case uid = "UID"
        case photoUID = "PhotoUID"
        case name = "Name"
        case root = "Root"
        case hash = "Hash"
        case size = "Size"
        case primary = "Primary"
        case codec = "Codec"
        case fileType = "FileType"
        case mediaType = "MediaType"
        case mime = "Mime"
        case width = "Width"
        case height = "Height"
        case orientation = "Orientation"
        case aspectRatio = "AspectRatio"
        case colors = "Colors"
        case luminance = "Luminance"
        case diff = "Diff"
        case chroma = "Chroma"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case markers = "Markers"
        case duration = "Duration"
        case fps = "FPS"
        case frames = "Frames"
        case portrait = "Portrait"
        case video = "Video"
        case instanceID = "InstanceID"
    }
}

// MARK: - Marker
struct Marker: Codable, Equatable, Hashable {
    let uid: String?
    let fileUID: String?
    let type: String?
    let src: String?
    let name: String?
    let review: Bool?
    let invalid: Bool?
    let faceID: String?
    let faceDist: Int?
    let subjUID: String?
    let subjSrc: String?
    let x: Double?
    let y: Double?
    let w: Double?
    let h: Double?
    let q: Int?
    let size: Int?
    let score: Int?
    let thumb: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case uid = "UID"
        case fileUID = "FileUID"
        case type = "Type"
        case src = "Src"
        case name = "Name"
        case review = "Review"
        case invalid = "Invalid"
        case faceID = "FaceID"
        case faceDist = "FaceDist"
        case subjUID = "SubjUID"
        case subjSrc = "SubjSrc"
        case x = "X"
        case y = "Y"
        case w = "W"
        case h = "H"
        case q = "Q"
        case size = "Size"
        case score = "Score"
        case thumb = "Thumb"
        case createdAt = "CreatedAt"
    }
}

 
