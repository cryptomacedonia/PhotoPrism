//
//  ContentView.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 3.7.23.
//

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
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if let backendImage = viewModel.hash {
                AsyncImage(url: URL(string: "https://demo-cdn.photoprism.app/api/v1/t/\(backendImage)/public/tile_224")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: width, maxHeight: height).cornerRadius(5).overlay(
                                VStack {
                                    Button(action: {
                                        print("thumb zoom clicked...")
                                    }, label: {
                                        Image(systemName: "plus.magnifyingglass").tint(.primary)
                                    })
                                    Spacer()
                                    Button(action: {
                                        print("thumb like clicked...")
                                    }, label: {
                                        Image(systemName: "heart").tint(.primary)
                                    })
                                }.padding(5), alignment: .leading)
                    case let .failure(error):
                        Image(systemName: "photo").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: width, maxHeight: height).cornerRadius(5).onAppear {
                                print(error)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            if let title = viewModel.title {
                let attrString = try? AttributedString(markdown: title.prefix(10).padding(toLength: 10, withPad: "  ", startingAt: 0), options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
                Text(attrString!).font(Font.caption)
                    .foregroundColor(.primary).frame(maxWidth: .infinity, alignment: .center)
            }
        }.frame(maxWidth: viewModel.width ?? .infinity, maxHeight: viewModel.height ?? .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var showDetail: Bool = false
    static var previews: some View {
        ZStack {
           
            GalleryViewThumbs { item in
                print("item")
                showDetail = true
            }
            if showDetail {
                PagerView {
                    print("onclose action")
                }
            }
        }
    }
}

struct GalleryViewThumbs: View {
    var onClickingThumb: (MediaItem)->()
    var viewModel: [MediaItem] = MediaItem.sampleItems()
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(viewModel) { card in

                    GaleryThumbNail(viewModel: card, width: 100, height: 100).onTapGesture {
                        print("tapped..\(card)")
                        onClickingThumb(card)
                    }
                }
            }
            .padding()
        }
    }
}
