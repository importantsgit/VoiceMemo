//
//  HomeView.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var pathModel: PathModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                pathModel.paths.removeLast()
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
