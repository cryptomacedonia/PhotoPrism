//
//  LocalPhotosService.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 5.7.23.
//

import Foundation
import UIKit
import Photos

enum PhotoAlbumViewModel {
    case regular(id: Int, title: String, count: Int, image: UIImage, isSelected: Bool)
    case allPhotos(id: Int, title: String, count: Int, image: UIImage, isSelected: Bool)

    var id: Int { switch self { case .regular(let params), .allPhotos(let params): return params.id } }
    var count: Int { switch self { case .regular(let params), .allPhotos(let params): return params.count } }
    var title: String { switch self { case .regular(let params), .allPhotos(let params): return params.title } }
}

class PhotoService {

    internal lazy var imageManager = PHCachingImageManager()

    private lazy var queue = DispatchQueue(label: "PhotoService_queue",
                                           qos: .default, attributes: .concurrent,
                                           autoreleaseFrequency: .workItem, target: nil)
    private lazy var getImagesQueue = DispatchQueue(label: "PhotoService_getImagesQueue",
                                                    qos: .userInteractive, attributes: [],
                                                    autoreleaseFrequency: .inherit, target: nil)
    private lazy var thumbnailSize = CGSize(width: 200, height: 200)
    private lazy var imageAlbumsIds = AtomicArray<Int>()
    private let getImageSemaphore = DispatchSemaphore(value: 12)

    typealias AlbumData = (fetchResult: PHFetchResult<PHAsset>, assetCollection: PHAssetCollection?)
    private let _cachedAlbumsDataSemaphore = DispatchSemaphore(value: 1)
    private lazy var _cachedAlbumsData = [Int: AlbumData]()

    deinit {
        print("____ PhotoServiceImpl deinited")
        imageManager.stopCachingImagesForAllAssets()
    }
}

// albums

extension PhotoService {

    private func getAlbumData(id: Int, completion: ((AlbumData?) -> Void)?) {
        _ = _cachedAlbumsDataSemaphore.wait(timeout: .now() + .seconds(3))
        if let cachedAlbum = _cachedAlbumsData[id] {
            completion?(cachedAlbum)
            _cachedAlbumsDataSemaphore.signal()
            return
        } else {
            _cachedAlbumsDataSemaphore.signal()
        }
        var result: AlbumData? = nil
        switch id {
            case 0:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                result = (allPhotos, nil)

            default:
                let collections = getAllAlbumsAssetCollections()
                let id = id - 1
                if  id < collections.count {
                    _fetchAssets(in: collections[id]) { fetchResult in
                        result = (fetchResult, collections[id])
                    }
                }
        }
        guard let _result = result else { completion?(nil); return }
        _ = _cachedAlbumsDataSemaphore.wait(timeout: .now() + .seconds(3))
        _cachedAlbumsData[id] = _result
        _cachedAlbumsDataSemaphore.signal()
        completion?(_result)
    }

    private func getAllAlbumsAssetCollections() -> PHFetchResult<PHAssetCollection> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        fetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        return PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    }

    func getAllAlbums(completion: (([PhotoAlbumViewModel])->Void)?) {
        queue.async { [weak self] in
            guard let self = self else { return }
            var viewModels = AtomicArray<PhotoAlbumViewModel>()

            var allPhotosAlbumViewModel: PhotoAlbumViewModel?
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            self.getAlbumData(id: 0) { data in
                   guard let data = data, let asset = data.fetchResult.lastObject else { dispatchGroup.leave(); return }
                self._fetchImage(from: asset, userInfo: nil, targetSize: self.thumbnailSize,
                                     deliveryMode: .fastFormat, resizeMode: .fast) { [weak self] (image, _) in
                                        guard let self = self, let image = image else { dispatchGroup.leave(); return }
                                        allPhotosAlbumViewModel = .allPhotos(id: 0, title: "All Photos",
                                                                             count: data.fetchResult.count,
                                                                             image: image, isSelected: false)
                                    self.imageAlbumsIds.append(0)
                                    dispatchGroup.leave()
                }
            }

            let numberOfAlbums = self.getAllAlbumsAssetCollections().count + 1
            for id in 1 ..< numberOfAlbums {
                dispatchGroup.enter()
                self.getAlbumData(id: id) { [weak self] data in
                    guard let self = self else { return }
                    guard let assetCollection = data?.assetCollection else { dispatchGroup.leave(); return }
                    self.imageAlbumsIds.append(id)
                    self.getAlbumViewModel(id: id, collection: assetCollection) { [weak self] model in
                        guard let self = self else { return }
                        defer { dispatchGroup.leave() }
                        guard let model = model else { return }
                        viewModels.append(model)
                    }
                }
            }

            _ = dispatchGroup.wait(timeout: .now() + .seconds(3))
            var _viewModels = [PhotoAlbumViewModel]()
            if let allPhotosAlbumViewModel = allPhotosAlbumViewModel {
                _viewModels.append(allPhotosAlbumViewModel)
            }
            _viewModels += viewModels.get()
            DispatchQueue.main.async { completion?(_viewModels) }
        }
    }

    private func getAlbumViewModel(id: Int, collection: PHAssetCollection, completion: ((PhotoAlbumViewModel?) -> Void)?) {
        _fetchAssets(in: collection) { [weak self] fetchResult in
            guard let self = self, let asset = fetchResult.lastObject else { completion?(nil); return }
            self._fetchImage(from: asset, userInfo: nil, targetSize: self.thumbnailSize,
                             deliveryMode: .fastFormat, resizeMode: .fast) { (image, nil) in
                                guard let image = image else { completion?(nil); return }
                                completion?(.regular(id: id,
                                                     title: collection.localizedTitle ?? "",
                                                     count: collection.estimatedAssetCount,
                                                     image: image, isSelected: false))
            }
        }
    }
}

// fetch

extension PhotoService {

    fileprivate func _fetchImage(from photoAsset: PHAsset,
                                 userInfo: [AnyHashable: Any]? = nil,
                                 targetSize: CGSize, //= PHImageManagerMaximumSize,
                                 deliveryMode: PHImageRequestOptionsDeliveryMode = .fastFormat,
                                 resizeMode: PHImageRequestOptionsResizeMode,
                                 completion: ((_ image: UIImage?, _ userInfo: [AnyHashable: Any]?) -> Void)?) {
        // guard authorizationStatus() == .authorized else { completion(nil); return }
        let options = PHImageRequestOptions()
        options.resizeMode = resizeMode
        options.isSynchronous = true
        options.deliveryMode = deliveryMode
        imageManager.requestImage(for: photoAsset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFill,
                                  options: options) { (image, info) -> Void in
                                    guard   let info = info,
                                            let isImageDegraded = info[PHImageResultIsDegradedKey] as? Int,
                                            isImageDegraded == 0 else { completion?(nil, nil); return }
                                    completion?(image, userInfo)
        }
    }

    private func _fetchAssets(in collection: PHAssetCollection, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        completion(assets)
    }

    private func fetchImage(from asset: PHAsset,
                            userInfo: [AnyHashable: Any]?,
                            targetSize: CGSize,
                            deliveryMode: PHImageRequestOptionsDeliveryMode,
                            resizeMode: PHImageRequestOptionsResizeMode,
                            completion:  ((UIImage?, _ userInfo: [AnyHashable: Any]?) -> Void)?) {
        queue.async { [weak self] in
            self?._fetchImage(from: asset, userInfo: userInfo, targetSize: targetSize,
                              deliveryMode: deliveryMode, resizeMode: resizeMode) { (image, _) in
                                DispatchQueue.main.async { completion?(image, userInfo) }
            }
        }
    }

    func getImage(albumId: Int, index: Int,
                  userInfo: [AnyHashable: Any]?,
                  targetSize: CGSize,
                  deliveryMode: PHImageRequestOptionsDeliveryMode,
                  resizeMode: PHImageRequestOptionsResizeMode,
                  completion:  ((_ image: UIImage?, _ userInfo: [AnyHashable: Any]?) -> Void)?) {
        getImagesQueue.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(item: index, section: albumId)
            self.getAlbumData(id: albumId) { data in
                _ = self.getImageSemaphore.wait(timeout: .now() + .seconds(3))
                guard let photoAsset = data?.fetchResult.object(at: index) else { self.getImageSemaphore.signal(); return }
                self.fetchImage(from: photoAsset,
                                userInfo: userInfo,
                                targetSize: targetSize,
                                deliveryMode: deliveryMode,
                                resizeMode: resizeMode) { [weak self] (image, userInfo) in
                                    defer { self?.getImageSemaphore.signal() }
                                    completion?(image, userInfo)
                }
            }
        }
    }
}

// https://developer.apple.com/documentation/swift/rangereplaceablecollection
struct AtomicArray<T>: RangeReplaceableCollection {

    typealias Element = T
    typealias Index = Int
    typealias SubSequence = AtomicArray<T>
    typealias Indices = Range<Int>
    fileprivate var array: Array<T>
    var startIndex: Int { return array.startIndex }
    var endIndex: Int { return array.endIndex }
    var indices: Range<Int> { return array.indices }

    func index(after i: Int) -> Int { return array.index(after: i) }

    private var semaphore = DispatchSemaphore(value: 1)
    fileprivate func _wait() { semaphore.wait() }
    fileprivate func _signal() { semaphore.signal() }
}

// MARK: - Instance Methods

extension AtomicArray {

    init<S>(_ elements: S) where S : Sequence, AtomicArray.Element == S.Element {
        array = Array<S.Element>(elements)
    }

    init() { self.init([]) }

    init(repeating repeatedValue: AtomicArray.Element, count: Int) {
        let array = Array(repeating: repeatedValue, count: count)
        self.init(array)
    }
}

// MARK: - Instance Methods

extension AtomicArray {

    public mutating func append(_ newElement: AtomicArray.Element) {
        _wait(); defer { _signal() }
        array.append(newElement)
    }

    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, AtomicArray.Element == S.Element {
        _wait(); defer { _signal() }
        array.append(contentsOf: newElements)
    }

    func filter(_ isIncluded: (AtomicArray.Element) throws -> Bool) rethrows -> AtomicArray {
        _wait(); defer { _signal() }
        let subArray = try array.filter(isIncluded)
        return AtomicArray(subArray)
    }

    public mutating func insert(_ newElement: AtomicArray.Element, at i: AtomicArray.Index) {
        _wait(); defer { _signal() }
        array.insert(newElement, at: i)
    }

    mutating func insert<S>(contentsOf newElements: S, at i: AtomicArray.Index) where S : Collection, AtomicArray.Element == S.Element {
        _wait(); defer { _signal() }
        array.insert(contentsOf: newElements, at: i)
    }

    mutating func popLast() -> AtomicArray.Element? {
        _wait(); defer { _signal() }
        return array.popLast()
    }

    @discardableResult mutating func remove(at i: AtomicArray.Index) -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.remove(at: i)
    }

    mutating func removeAll() {
        _wait(); defer { _signal() }
        array.removeAll()
    }

    mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        _wait(); defer { _signal() }
        array.removeAll()
    }

    mutating func removeAll(where shouldBeRemoved: (AtomicArray.Element) throws -> Bool) rethrows {
        _wait(); defer { _signal() }
        try array.removeAll(where: shouldBeRemoved)
    }

    @discardableResult mutating func removeFirst() -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.removeFirst()
    }

    mutating func removeFirst(_ k: Int) {
        _wait(); defer { _signal() }
        array.removeFirst(k)
    }

    @discardableResult mutating func removeLast() -> AtomicArray.Element {
        _wait(); defer { _signal() }
        return array.removeLast()
    }

    mutating func removeLast(_ k: Int) {
        _wait(); defer { _signal() }
        array.removeLast(k)
    }

    @inlinable public func forEach(_ body: (Element) throws -> Void) rethrows {
        _wait(); defer { _signal() }
        try array.forEach(body)
    }

    mutating func removeFirstIfExist(where shouldBeRemoved: (AtomicArray.Element) throws -> Bool) {
        _wait(); defer { _signal() }
        guard let index = try? array.firstIndex(where: shouldBeRemoved) else { return }
        array.remove(at: index)
    }

    mutating func removeSubrange(_ bounds: Range<Int>) {
        _wait(); defer { _signal() }
        array.removeSubrange(bounds)
    }

    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C) where C : Collection, R : RangeExpression, T == C.Element, AtomicArray<Element>.Index == R.Bound {
        _wait(); defer { _signal() }
        array.replaceSubrange(subrange, with: newElements)
    }

    mutating func reserveCapacity(_ n: Int) {
        _wait(); defer { _signal() }
        array.reserveCapacity(n)
    }

    public var count: Int {
        _wait(); defer { _signal() }
        return array.count
    }

    public var isEmpty: Bool {
        _wait(); defer { _signal() }
        return array.isEmpty
    }
}

// MARK: - Get/Set

extension AtomicArray {

    // Single  action

    func get() -> [T] {
        _wait(); defer { _signal() }
        return array
    }

    mutating func set(array: [T]) {
        _wait(); defer { _signal() }
        self.array = array
    }

    // Multy actions

    mutating func get(closure: ([T])->()) {
        _wait(); defer { _signal() }
        closure(array)
    }

    mutating func set(closure: ([T]) -> ([T])) {
        _wait(); defer { _signal() }
        array = closure(array)
    }
}

// MARK: - Subscripts

extension AtomicArray {

    subscript(bounds: Range<AtomicArray.Index>) -> AtomicArray.SubSequence {
        get {
            _wait(); defer { _signal() }
            return AtomicArray(array[bounds])
        }
    }

    subscript(bounds: AtomicArray.Index) -> AtomicArray.Element {
        get {
            _wait(); defer { _signal() }
            return array[bounds]
        }
        set(value) {
            _wait(); defer { _signal() }
            array[bounds] = value
        }
    }
}

// MARK: - Operator Functions

extension AtomicArray {

    static func + <Other>(lhs: Other, rhs: AtomicArray) -> AtomicArray where Other : Sequence, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs + rhs.get())
    }

    static func + <Other>(lhs: AtomicArray, rhs: Other) -> AtomicArray where Other : Sequence, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs.get() + rhs)
    }

    static func + <Other>(lhs: AtomicArray, rhs: Other) -> AtomicArray where Other : RangeReplaceableCollection, AtomicArray.Element == Other.Element {
        return AtomicArray(lhs.get() + rhs)
    }

    static func + (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> AtomicArray {
        return AtomicArray(lhs.get() + rhs.get())
    }

    static func += <Other>(lhs: inout AtomicArray, rhs: Other) where Other : Sequence, AtomicArray.Element == Other.Element {
        lhs._wait(); defer { lhs._signal() }
        lhs.array += rhs
    }
}

// MARK: - CustomStringConvertible

extension AtomicArray: CustomStringConvertible {
    var description: String {
        _wait(); defer { _signal() }
        return "\(array)"
    }
}

// MARK: - Equatable

extension AtomicArray where Element : Equatable {

    func split(separator: Element, maxSplits: Int, omittingEmptySubsequences: Bool) -> [ArraySlice<Element>] {
        _wait(); defer { _signal() }
        return array.split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
    }

    func firstIndex(of element: Element) -> Int? {
        _wait(); defer { _signal() }
        return array.firstIndex(of: element)
    }

    func lastIndex(of element: Element) -> Int? {
        _wait(); defer { _signal() }
        return array.lastIndex(of: element)
    }

    func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool where PossiblePrefix : Sequence, Element == PossiblePrefix.Element {
        _wait(); defer { _signal() }
        return array.starts(with: possiblePrefix)
    }

    func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool where OtherSequence : Sequence, Element == OtherSequence.Element {
        _wait(); defer { _signal() }
        return array.elementsEqual(other)
    }

    func contains(_ element: Element) -> Bool {
        _wait(); defer { _signal() }
        return array.contains(element)
    }

    static func != (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> Bool {
        lhs._wait(); defer { lhs._signal() }
        rhs._wait(); defer { rhs._signal() }
        return lhs.array != rhs.array
    }

    static func == (lhs: AtomicArray<Element>, rhs: AtomicArray<Element>) -> Bool {
        lhs._wait(); defer { lhs._signal() }
        rhs._wait(); defer { rhs._signal() }
        return lhs.array == rhs.array
    }
}
