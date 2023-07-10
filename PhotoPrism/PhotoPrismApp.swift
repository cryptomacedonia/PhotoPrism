//
//  PhotoPrismApp.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 3.7.23.
//

import Alamofire
import Debounce
import SwiftUI
@main


//var apiUrl  = "https://demo-cdn.photoprism.app"
struct PhotoPrismApp: App {
    var photoLibrary = PhotoService()
    @Namespace var namespace
    @State var showDetail: Bool = false
    @State var selectedItem: MediaItem = MediaItem.sampleItems()[0]
    @State var mediaItems = MediaItem.sampleItems(count: 100)
    @State var searchText: String = ""
    @State var searchIsActive = false
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ZStack {
                    GalleryViewThumbs(viewModel: mediaItems,
                                      onClickingMagnifyingGlass: {
                                          selectedItem = $0
                                          showDetail = true
                                      },
                                      onClickingLike:
                                      { mediaItems[mediaItems.firstIndex(of: $0)!].liked.toggle() },

                                      onClickingSelect: {
                                          mediaItems[mediaItems.firstIndex(of: $0)!].selected.toggle()

                                      }).padding(10).searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Look for something").onChange(of: searchText) { newQuery in
                                          searchForPhotos(searchText: newQuery)
                                      }

                    if showDetail {
                        let idx = mediaItems.firstIndex(of: self.selectedItem)!
                        PagerView(selectedTabIndex: idx, mediaItems: mediaItems) {
                            showDetail = false
                        }.frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude).modifier(DraggableModifier(direction: .vertical)).onAppear {
                            searchIsActive = false
                        }
                    }
                }
            }.onAppear {
                
                MediaItem.getImagesFromPhotoPrismTest { items in
                    if !apiUrl.hasPrefix("https://demo") {
                        mediaItems = items
                    }
                }
            }
        }
    }

    func searchForPhotos(searchText: String) {
        AF.request("\(apiUrl)/api/v1/photos?count=120&q=\(searchText)", method: .get, parameters: nil, encoding:URLEncoding.default, headers: nil, interceptor: nil)
//        AF.request("https://demo.photoprism.app/api/v1/photos?count=120&offset=0&merged=true&country=&camera=0&lens=0&label=&year=0&month=0&color=&order=newest&q=\(searchText)&public=true&quality=3", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response { resp in
                switch resp.result {
                case let .success(data):
                    do {
                        let jsonData = try JSONDecoder().decode([MediaItem].self, from: data!)
                        print(jsonData)
                        self.mediaItems = jsonData
                    } catch {
                        print(error.localizedDescription)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
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

    for i in 0 ..< fetchResult.count {
        let asset = fetchResult.object(at: i)

        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil) { thumbnail, _ in
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

        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions) { image, _ in
            completion(image)
        }
    } else {
        completion(nil)
    }
}

struct DraggableModifier: ViewModifier {
    enum Direction {
        case vertical
        case horizontal
    }

    let direction: Direction

    @State private var draggedOffset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .offset(
                CGSize(width: direction == .vertical ? 0 : draggedOffset.width,
                       height: direction == .horizontal ? 0 : draggedOffset.height)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.draggedOffset = value.translation
                    }
                    .onEnded { _ in
                        self.draggedOffset = .zero
                    }
            )
    }
}

//var apiUrl  = "https://photoprism.celliqa.com"
var apiUrl  = "https://demo-cdn.photoprism.app"
