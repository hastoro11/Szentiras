//
//  AppTabView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct AppTabView: View {
    @State var selectedTab = 3
    @State var editMode: EditMode = .inactive
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
            NoteListView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Jegyzetek")
                }
                .tag(2)
            FavoritesView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "star")
                    Text("Kedvencek")
                }
                .tag(3)
                .environment(\.editMode, $editMode)
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
