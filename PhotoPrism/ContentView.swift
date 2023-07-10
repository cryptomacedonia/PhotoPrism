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

struct GaleryThumbNail: View {
    let viewModel: MediaItem
    let width: CGFloat = 100
    let height: CGFloat = 100
    var onClickingSelect: (MediaItem) -> Void
    var onClickingLike: (MediaItem) -> Void
    var onClickingMagnifyingGlass: (MediaItem) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            if let backendImage = viewModel.hash {
               // Image("tile_224")
                KFImage(URL(string: "\(apiUrl)/api/v1/t/\(backendImage)/public/tile_224"))
                    .resizable()
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
                        }.padding(5), alignment: .leading).opacity(viewModel.selected ? 0.5 : 1.0)
            }

//            if let title = viewModel.title , viewModel.showTitle {
//                let attrString = try? AttributedString(markdown: title.prefix(10).padding(toLength: 10, withPad: "  ", startingAt: 0), options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
//                Text(attrString!).font(Font.caption)
//                    .foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .center)
//            }
        }.onTapGesture {
            onClickingSelect(viewModel)
            }
    }
}

struct GalleryViewThumbs: View {
    var viewModel: [MediaItem]
    var onClickingMagnifyingGlass: (MediaItem) -> Void
    var onClickingLike: (MediaItem) -> Void
    var onClickingSelect: (MediaItem) -> Void
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel) { card in
                        GaleryThumbNail(viewModel: card, onClickingSelect: onClickingSelect, onClickingLike: onClickingLike, onClickingMagnifyingGlass: onClickingMagnifyingGlass)
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
