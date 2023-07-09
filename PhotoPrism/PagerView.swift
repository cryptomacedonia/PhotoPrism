//
//  PagerView.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 7.7.23.
//

import Foundation
import SwiftUI

struct PagerView: View {
    var onCloseAction:()->()
    @State private var selectedTabIndex: Int
    init(selectedTabIndex: Int = 0,onCloseAction:@escaping ()->(), photosArray:[MediaItem] = []) {
           self._selectedTabIndex = State(initialValue: selectedTabIndex)
        self.onCloseAction = onCloseAction
       }
    var body: some View {
        VStack {
            Button("close") {
                print("close button")
                onCloseAction()
            }
            TabView(selection:$selectedTabIndex) {
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red).tag(0)
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue).tag(1)
                Text("3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.green).tag(2)
                Text("4")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.yellow).tag(3)
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)).ignoresSafeArea()
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
