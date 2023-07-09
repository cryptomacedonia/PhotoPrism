//
//  ContentView.swift
//  PhotoPrism
//
//  Created by Igor Jovcevski on 3.7.23.
//

import SwiftUI

struct SideMenuRowViewModel {
    var title: String?
    var subTitle: String?
    var rightTitle: String?
    var rightSubTitle: String?
    var leftIcon: AsyncImage<Image>?
    var rightIcon: AsyncImage<Image>?
}

struct SideMenuRowView: View {
    var viewModel: SideMenuRowViewModel

    var body: some View {
        HStack(spacing: 10) {
            if let leftIcon = viewModel.leftIcon {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 40, height: 40)
                    .background(
                        leftIcon
                    )
            }

            VStack(alignment: .leading) {
                if let title = viewModel.title {
                    Text(title)
                        .font(Font.title3)
                        .foregroundColor(.primary)
                }
                if let subtitle = viewModel.subTitle {
                    Text(subtitle)
                        .font(Font.subheadline)
                        .foregroundColor(.primary)
                }
            }

            Spacer()
            VStack(alignment: .trailing) {
                if let rightTitle = viewModel.rightTitle {
                    Text(rightTitle)
                        .font(Font.title3)
                        .foregroundColor(.primary)
                }
                if let rightSubTitleTitle = viewModel.rightSubTitle {
                    Text(rightSubTitleTitle)
                        .font(Font.subheadline)
                        .foregroundColor(.primary)
                }
            }
            if let rightIcon = viewModel.rightIcon {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 40, height: 40)
                    .background(
                        rightIcon
                    )
            }
        }.padding(.horizontal)
    }
}

struct SideMenuRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SideMenuRowView(viewModel: .init(title: "Title",
                                             subTitle: "subtitle",
                                             rightTitle: "rightTitle",
                                             rightSubTitle: "RightSubtitle",
                                             leftIcon: AsyncImage(url: URL(string: "https://via.placeholder.com/40x40")),
                                             rightIcon: AsyncImage(url: URL(string: "https://via.placeholder.com/40x40"))))
            SideMenuRowView(viewModel: .init(
                                             rightTitle: "rightTitle",
                                             leftIcon: AsyncImage(url: URL(string: "https://via.placeholder.com/40x40")),
                                             rightIcon: AsyncImage(url: URL(string: "https://via.placeholder.com/40x40"))))
        }
    }
}
