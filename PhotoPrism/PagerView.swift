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
    var mediaItems: [MediaItem]
    init(selectedTabIndex: Int = 0, mediaItems: [MediaItem] = [], onCloseAction: @escaping () -> Void) {
        _selectedTabIndex = State(initialValue: selectedTabIndex)
        self.onCloseAction = onCloseAction
        self.mediaItems = mediaItems
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
                    KFImage(URL(string: "\(apiUrl)/api/v1/t/\(item.hash!)/\(apiUrl.hasPrefix("https://demo") ? "jdtij5ua" : "2p5fjgyq")/fit_2048"))
                        .resizable().aspectRatio(contentMode: .fit).frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black).tag(index)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).ignoresSafeArea(edges: .init(.bottom))
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        PagerView(selectedTabIndex: 0) {
            print("onclose action")
        }
    }
}
