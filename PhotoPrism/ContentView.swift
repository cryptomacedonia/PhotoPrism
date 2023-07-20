//
//  ContentView.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 3.7.23.
//

import Kingfisher
import SwiftUI
struct GaleryThumbNailViewModel: Identifiable {
    var id: String = UUID().uuidString
    var backendImage: URL?
    var localImage: String?
    var cornerRadius: CGFloat = 5.0
    var title: String?
    var subTitle: String?
    var width: CGFloat?
    var height: CGFloat?
}


struct GaleryThumbNail2: View {
    @Binding var viewModel: MediaItem
    let width: CGFloat = 100
    let height: CGFloat = 100
    var onClickingSelect: (MediaItem) -> Void
    var onClickingLike: (MediaItem) -> Void
    var onClickingMagnifyingGlass: (MediaItem) -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
//            if let backendImage = viewModel.hash {
//               // Image("tile_224")
//                KFImage(URL(string: "\(apiUrl)/api/v1/t/\(backendImage)/public/tile_224"))
//                    .resizable()
////                KFImage(URL(string: "https://demo-cdn.photoprism.app/api/v1/t/\(backendImage)/public/tile_224"))
////                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .cornerRadius(5)
////                    .overlay(
////                        VStack {
////                            Button(action: {
////                                print("thumb zoom clicked...")
////                                onClickingMagnifyingGlass(viewModel)
////                            }, label: {
////                                Image(systemName: "plus.magnifyingglass").tint(.primary)
////                            })
////                            Spacer()
////                            Button(action: {
////                                print("thumb like clicked...")
////                                onClickingLike(viewModel)
////                            }, label: {
////                                Image(systemName: viewModel.liked ? "heart.fill" : "heart").tint(.primary)
////                            })
////                        }.padding(5), alignment: .leading)
//                    .opacity(viewModel.selected ? 0.5 : 1.0).onTapGesture {
//                        onClickingSelect(viewModel)
//                        }
//            }
//
////            if let title = viewModel.title , viewModel.showTitle {
////                let attrString = try? AttributedString(markdown: title.prefix(10).padding(toLength: 10, withPad: "  ", startingAt: 0), options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
////                Text(attrString!).font(Font.caption)
////                    .foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .center)
////            }
        }.id(UUID()).frame(width:100, height: 100).background(.yellow).opacity(viewModel.selected ? 0.5 : 1.0).onTapGesture {
            onClickingSelect(viewModel)
            }
    }
}

struct GaleryThumbNail: View {
    @Binding var viewModel: MediaItem
    let width: CGFloat = 100
    let height: CGFloat = 100
    var onClickingSelect: (MediaItem) -> Void
    var onClickingLike: (MediaItem) -> Void
    var onClickingMagnifyingGlass: (MediaItem) -> Void
    var serverIp:String
    var body: some View {
        Button {
            withAnimation (.easeInOut(duration: 0.3)) {
                onClickingSelect(viewModel)
            }
                
        } label: {
            
            
            
            VStack(alignment: .center, spacing: 3) {
                if let backendImageUrl = viewModel.fileName {
                    // Image("tile_224")
                    KFImage(URL(string: "http://\(serverIp):8888/thumbnails/\(backendImageUrl)" ))
                        .resizable()
//                    KFImage(URL(string: "\(apiUrl)/api/v1/t/\(backendImage)/public/tile_224"))
//                        .resizable()
                    //                KFImage(URL(string: "https://demo-cdn.photoprism.app/api/v1/t/\(backendImage)/public/tile_224"))
                    //                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(5).overlay(
                            VStack {
                                Button(action: {
                                    print("thumb zoom clicked...")
                                    onClickingMagnifyingGlass(viewModel)
                                }, label: {
                                    Image(systemName: "plus.magnifyingglass").tint(.primary)
                                })
                                Spacer()
                                Button(action: {
                                    print("thumb like clicked...")
                                    onClickingLike(viewModel)
                                }, label: {
                                    Image(systemName: viewModel.liked ? "heart.fill" : "heart").tint(.primary)
                                })
                            }.padding(5), alignment: .leading).opacity(viewModel.selected ? 0.3 : 1.0).padding(viewModel.selected ? 5 : 0)
                }
                
                //            if let title = viewModel.title , viewModel.showTitle {
                //                let attrString = try? AttributedString(markdown: title.prefix(10).padding(toLength: 10, withPad: "  ", startingAt: 0), options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
                //                Text(attrString!).font(Font.caption)
                //                    .foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .center)
                //            }
            }
        }
       
    }
}
//struct GalleryViewThumbsGrid3: View {
//    @Binding var viewModel: [MediaItem]
//    var onClickingMagnifyingGlass: (MediaItem) -> Void
//    var onClickingLike: (MediaItem) -> Void
//    var onClickingSelect: (MediaItem) -> Void
//    var selectedImageID: String = ""
//    var body: some View {
//        let columns = [
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
//        ]
//        ScrollView {
//            Grid {
//                
//                ForEach(0..<viewModel.count/3) { row in // create number of rows
//                    GridRow {
//                        ForEach(0..<3) { column in // create 3 columns
//                            
//                            GaleryThumbNail(viewModel: $viewModel[row * 3 + column], onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
//                                           }
//                    }
//                }
//            }
//        }
////        List($viewModel) { card in
////            GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
////        }
////        ScrollView {
////                LazyVGrid(columns: columns) {
////                    ForEach($viewModel) { card in
////                        GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
////                    }
////                }
//////            LazyVGrid(columns: columns, spacing: 5) {
//////                ForEach(viewModel) { card in
//////                    GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
//////                }
//////            }
//////            .padding()
////        }
//    }
//}
struct GalleryViewThumbs: View {
    @Binding var viewModel: [MediaItem]
    var onClickingMagnifyingGlass: (MediaItem) -> Void
    var onClickingLike: (MediaItem) -> Void
    var onClickingSelect: (MediaItem) -> Void
    var serverIp:String
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
//        List($viewModel) { card in
//            GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
//        }
        ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach($viewModel) { card in
                        GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass, serverIp: serverIp)
                    }
                }
//            LazyVGrid(columns: columns, spacing: 5) {
//                ForEach(viewModel) { card in
//                    GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
//                }
//            }
//            .padding()
        }
    }
}



struct PhotoGridView: View {
    let imageUrls: [String]
    @State private var selectedImageUrl: String?
    @State private var isFullScreen: Bool = false
    
    var body: some View {
        ZStack {
            GridView(imageUrls: imageUrls, selectedImageUrl: $selectedImageUrl, isFullScreen: $isFullScreen)
            
            if isFullScreen {
                FullScreenImageCarousel(imageUrls: imageUrls, selectedImageUrl: $selectedImageUrl, isFullScreen: $isFullScreen)
            }
        }
    }
}

struct GridView: View {
    let imageUrls: [String]
    @Binding var selectedImageUrl: String?
    @Binding var isFullScreen: Bool
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 10) {
                ForEach(imageUrls, id: \.self) { imageUrl in
                    Button(action: {
                        selectedImageUrl = imageUrl
                        withAnimation (.easeInOut(duration: 0.3)) {
                            isFullScreen = true
                        }
                    }) {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 120)
                                .cornerRadius(10)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .padding()
        }
    }
}


struct FullScreenImageCarousel: View {
    let imageUrls: [String]
    @Binding var selectedImageUrl: String?
    @Binding var isFullScreen: Bool
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGSize = .zero
    @State private var isAnimating: Bool = false
    @State private var dismissOffset: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack {
                    HStack(spacing: 0) {
                        ForEach(imageUrls, id: \.self) { imageUrl in
                            GeometryReader { itemGeometry in
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: geometry.size.width)
                                        .cornerRadius(10)
                                        .opacity(itemGeometry.frame(in: .global).midX == geometry.size.width / 2 ? 1 : 0)
                                        .scaleEffect(itemGeometry.frame(in: .global).midX == geometry.size.width / 2 ? 1 : 0.8)
                                        .animation(.easeInOut(duration: 0.3))
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geometry.size.width)
                                .position(x: itemGeometry.frame(in: .global).midX, y: itemGeometry.frame(in: .global).midY)
                            }
                            .frame(width: geometry.size.width)
                        }
                    }
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: offset + dragOffset.width)
                    .animation(isAnimating ? .none : .default)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                                isAnimating = true
                            }
                            .onEnded { value in
                                let swipeDistance = value.translation.width
                                let screenWidth = geometry.size.width
                                let threshold = screenWidth * 0.4
                                
                                if swipeDistance < -threshold && currentIndex < imageUrls.count - 1 {
                                    currentIndex += 1
                                } else if swipeDistance > threshold && currentIndex > 0 {
                                    currentIndex -= 1
                                }
                                
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    offset = -CGFloat(currentIndex) * screenWidth
                                    dragOffset = .zero
                                    isAnimating = false
                                }
                                
                                selectedImageUrl = imageUrls[currentIndex]
                            }
                    )
                    
                    Spacer()
                }
                
                Button(action: {
                    withAnimation (.easeInOut(duration: 0.3)) {
                        isFullScreen = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.red)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .padding(.top, geometry.safeAreaInsets.top)
                
                if dragOffset.height > 0 {
                    AsyncImage(url: URL(string: selectedImageUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: geometry.size.width - 40)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if value.translation.height > 0 {
                                            dragOffset.height = value.translation.height + dismissOffset
                                        }
                                    }
                                    .onEnded { value in
                                        if dragOffset.height > geometry.size.height * 0.4 {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                dismissOffset = geometry.size.height
                                            }
                                            isFullScreen = false
                                        } else {
                                            withAnimation (.easeInOut(duration: 0.3)) {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: geometry.size.width - 40)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + dragOffset.height)
                    .animation(.default)
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let index = imageUrls.firstIndex(of: selectedImageUrl ?? "") {
                currentIndex = index
                offset = -CGFloat(index) * UIScreen.main.bounds.width
            }
        }
    }
}
