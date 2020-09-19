//
//  AppTabView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct AppTabView: View {
    @State var selectedTab = 1
    var body: some View {
        TabView(selection: $selectedTab) {
            BookView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Könyvek")
                }
                .tag(0)
            ReadingView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "book")
                    Text("Olvasás")
                }
                .tag(1)
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
