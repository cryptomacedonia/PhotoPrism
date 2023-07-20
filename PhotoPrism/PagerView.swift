//
//  PagerView.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 7.7.23.
//

import Foundation
import Kingfisher
import SwiftUI
struct PagerView: View {
    var onCloseAction: () -> Void
   
    @State private var selectedTabIndex: Int
    var draggedOffset: CGSize = .zero
    var mediaItems: [MediaItem]
    var serverIp: String
    init(selectedTabIndex: Int = 0, mediaItems: [MediaItem] = [], serverIp:String ,onCloseAction: @escaping () -> Void) {
        _selectedTabIndex = State(initialValue: selectedTabIndex)
        self.onCloseAction = onCloseAction
        self.mediaItems = mediaItems
        self.serverIp = serverIp
    }

    var body: some View {
        VStack(spacing: 0.0) {
            Button(action: {
                onCloseAction()
            }) {
                HStack {
                    Spacer()
                    Text("Close")
                    Spacer()
                }.frame(height: 80).background(.black)
            }
            TabView(selection: $selectedTabIndex) {
                ForEach(Array(mediaItems.enumerated()), id: \.1) { index, item in
//                    KFImage(URL(string: "https://demo-cdn.photoprism.app/api/v1/t/\(item.hash!)/jdtij5ua/fit_1280")) apiUrl.hasPrefix("https://demo") ? "jdtij5ua" : "2p5fjgyq"
//                    KFImage(URL(string: "\(apiUrl)/api/v1/t/\(item.hash!)/\(apiUrl.hasPrefix("https://demo") ? "jdtij5ua" : "2p5fjgyq")/fit_2048"))
                    KFImage(URL(string: "http://\(serverIp):8888/fullresphotos/\(item.fileName!)"))
                        .resizable().aspectRatio(contentMode: .fit).frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black).tag(index).offset(draggedOffset)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).ignoresSafeArea(edges: .init(.bottom))
        }
    }
}

