//
//  FavoritesView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 27..
//

import SwiftUI

struct FavoritesView: View {
    @Binding var selectedTab: Int
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(selectedTab: .constant(3))
    }
}
