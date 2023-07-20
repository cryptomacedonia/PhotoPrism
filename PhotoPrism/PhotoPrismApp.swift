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



// var apiUrl  = "https://demo-cdn.photoprism.app"

struct PhotoPrismApp: App {
    var photoLibrary = PhotoService()
    @Namespace var namespace
    @State var showDetail: Bool = false
    @State var selectedItem: MediaItem = MediaItem.sampleItems()[0]
    @State var mediaItems = MediaItem.sampleItems(count: 0)
    @State var searchText: String = ""
    @State var searchIsActive = false
    @State var showQRScanner = false
    @State var scannedConfig:IPConfStruct?
    var body: some Scene {
        WindowGroup {
            VStack {
                !showQRScanner ? Button {
                    print("connecting...")
                    showQRScanner.toggle()
                } label: {
                    Text("QR Code")
                } : nil
                showQRScanner ? QRScannerView() { code in
                    
                    scannedConfig = try? JSONDecoder().decode(IPConfStruct.self, from: Data(code.utf8))
                    AF.request("http://\(scannedConfig!.external_ip!):8888/photos", method: .get, parameters: nil, encoding:URLEncoding.default, headers: nil, interceptor: nil)
                        .response { resp in
                            switch resp.result {
                            case let .success(data):
                                do {
                                    let jsonData = try JSONDecoder().decode([String].self, from: data!)
                                    showQRScanner.toggle()
                                    mediaItems = jsonData.map({ item in
                                        let mediaItem = MediaItem(uid: "example_uid", type: "example_type", typeSrc: "example_typeSrc", takenAt: "2023-07-30", takenAtLocal: "2023-07-30", takenSrc: "example_takenSrc", timeZone: "example_timeZone", path: "example_path", name: "example_name", originalName: "example_originalName", title: "example_title", description: "example_description", year: 2023, month: 7, day: 30, country: "example_country", stack: 1, favorite: true, mediaItemPrivate: false, iso: 200, focalLength: 50, fNumber: 1.8, exposure: "example_exposure", quality: 10, resolution: 1920, color: 16777215, scan: false, panorama: false, cameraID: 1, cameraModel: "example_cameraModel", lensID: 2, lensModel: "example_lensModel", lat: 37.7749, lng: -122.4194, cellID: "example_cellID", placeID: "example_placeID", placeSrc: "example_placeSrc", placeLabel: "example_placeLabel", placeCity: "example_placeCity", placeState: "example_placeState", placeCountry: "example_placeCountry", instanceID: "example_instanceID", fileUID: "example_fileUID", fileRoot: "example_fileRoot", fileName: item, hash: "example_hash", width: 1920.0, height: 1080.0, portrait: false, merged: true, createdAt: "example_createdAt", updatedAt: "example_updatedAt", editedAt: "example_editedAt", checkedAt: "example_checkedAt", deletedAt: "example_deletedAt", files: nil, cameraSrc: "example_cameraSrc", cameraMake: "example_cameraMake", altitude: 100, lensMake: "example_lensMake", documentID: "example_documentID", cameraSerial: "example_cameraSerial", cellAccuracy: 5, faces: 2)
                                           
                                        return mediaItem
                                    })
                                } catch {
                                    print(error.localizedDescription)
                                }
                            case let .failure(error):
                                print(error.localizedDescription)
                            }
                        }
                } : nil
                !mediaItems.isEmpty ? ZStack {
                    GalleryViewThumbs(viewModel: $mediaItems,
                                      onClickingMagnifyingGlass: {
                                          selectedItem = $0
                                          showDetail = true
                                      },
                                      onClickingLike:
                                      { mediaItems[mediaItems.firstIndex(of: $0)!].liked.toggle() },

                                      onClickingSelect: {
                                          mediaItems[mediaItems.firstIndex(of: $0)!].selected.toggle()

                    }, serverIp: scannedConfig!.external_ip!).padding(10).searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Look for something").onChange(of: searchText) { newQuery in
                        searchForPhotos(searchText: newQuery)
                    }

                    if showDetail {
                        let idx = mediaItems.firstIndex(of: self.selectedItem)!
                        PagerView(selectedTabIndex: idx, mediaItems: mediaItems, serverIp: scannedConfig!.external_ip!) {
                            showDetail = false
                        }

                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude).modifier(DraggableModifier(direction: .vertical)).onAppear {
                            searchIsActive = false
                        }
                        //                    }
                    }

                } : nil
            }
        }
    }

    func searchForPhotos(searchText: String) {
        AF.request("\(apiUrl)/api/v1/photos?count=120&q=\(searchText)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
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

// var apiUrl  = "https://photoprism.celliqa.com"
var apiUrl = "https://demo-cdn.photoprism.app"

import Kingfisher
import SwiftUI

import SwiftUI

import SwiftUI

struct GalleryView: View {
    let imageUrls: [String]

    @State private var selectedImageUrl: String? = nil
    @State private var isShowingFullscreen: Bool = false
    @Namespace private var namespace

    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(imageUrls, id: \.self) { imageUrl in
                    Button(action: {
                        selectedImageUrl = imageUrl
                        isShowingFullscreen = true
                    }) {
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case let .success(image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding()
            .sheet(item: $selectedImageUrl) { imageUrl in
                FullscreenView(imageUrl: imageUrl, isShowingFullscreen: $isShowingFullscreen, namespace: namespace)
                    .onDisappear {
                        selectedImageUrl = nil
                    }
            }
            .animation(.easeInOut)

            Spacer()
        }
    }
}

struct FullscreenView: View {
    let imageUrl: String
    @Binding var isShowingFullscreen: Bool
    let namespace: Namespace.ID

    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        .gesture(dragGesture)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        .foregroundColor(.red)
                        .gesture(dragGesture)
                @unknown default:
                    EmptyView()
                }
            }
            .matchedGeometryEffect(id: imageUrl, in: namespace)
            .onTapGesture {
                isShowingFullscreen = false
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 100 {
                    isShowingFullscreen = false
                }
            }
    }
}

struct ContentView: View {
    let imageUrls = [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg",
        "https://example.com/image3.jpg",
        "https://example.com/image4.jpg",
    ]

    var body: some View {
        GalleryView(imageUrls: imageUrls)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String: Identifiable {
    public var id: String { return self }
}

import AVFoundation
struct QRScannerView: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String = ""
    var onScanningCode:(String)->Void
    var body: some View {
        VStack {
            if !isShowingScanner {
                Button("Scan QR Code") {
                    isShowingScanner.toggle()
                }
            } else {
                ZStack {
                    QRCodeScannerView(scannedCode: $scannedCode, isShowingScanner: $isShowingScanner, onScanningCode: onScanningCode)
                    VStack {
                        Spacer()
                        Text("Scanned QR Code: \(scannedCode)")
                            .foregroundColor(.white)
                            .padding()
                      
                    }
                }
            }
        }
    }
}

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String
    @Binding var isShowingScanner: Bool
    var onScanningCode:(String)->Void
    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let scannerViewController = QRCodeScannerViewController { code in
            scannedCode = code
            isShowingScanner = false
            onScanningCode(code)
        }
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {
        // Empty
    }
}

class QRCodeScannerViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var codeHandler: (String) -> Void

    init(codeHandler: @escaping (String) -> Void) {
        self.codeHandler = codeHandler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
    }

    private func setupCaptureSession() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scanningNotPossible()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            scanningNotPossible()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func scanningNotPossible() {
        // Show an error message or handle the situation when QR scanning is not possible on this device.
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }

            codeHandler(stringValue)
        }
    }
}


//struct QRScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRScannerView()
//    }
//}

struct PhotoStruct: Codable {
    let fileName: String
}

struct IPConfStruct: Codable {
    let localipAndPort: String?
    let external_ip: String?
    let router: String?
    let gateway: String?
}

extension URL {
    func isReachable(completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }
}
