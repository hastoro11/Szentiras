//
//  FavoritesView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 27..
//

import SwiftUI


struct FavoritesView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var store: BibliaStore
    @Environment(\.editMode) var editMode
    @Environment(\.managedObjectContext) var context
    
    var favouritesDictionary: [String: [FavoriteVers]] {
        store.favouritesDictionary
    }
    var keys: [String] {
        Array(store.favouritesDictionary.keys)
    }
    var emptyDictionary: Bool {
        store.favouritesDictionary["Red"]!.isEmpty &&
            store.favouritesDictionary["Yellow"]!.isEmpty &&
            store.favouritesDictionary["Blue"]!.isEmpty &&
            store.favouritesDictionary["Green"]!.isEmpty
    }
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Text("Kedvencek")
                        .font(.medium16)
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                            }
                        }) {
                            Group {
                                if editMode?.wrappedValue == .inactive {
                                    Image(systemName: "list.number")
                                        .font(.medium22)
                                } else {
                                    Image(systemName: "checkmark")
                                        .font(.medium22)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
            
            if emptyDictionary {
                Divider()
                Spacer()
                Text("Nincsenek még kedvencek")
                    .font(.light18)
                Spacer()
            } else {
                List {
                    ForEach(keys.sorted(), id:\.self) { color in
                        if !favourites(color: color).isEmpty {
                            Section(header: headerView(color: color)) {
                                ForEach(favourites(color: color).sorted()) { fav in
                                    versRow(vers: fav, color: color)
                                        
                                }
                                .onDelete(perform: {indexSet in
                                    store.deleteFavourites(color: color, indexSet: indexSet)
                                })
                                .onMove { (indexSet, newOffset) in
                                    store.moveFavourites(color: color, indexSet: indexSet, newOffset: newOffset)
                                }
                                
                            }
                        }
                    }
                    
                }
                .padding(.horizontal)
            }
            
            
        }
    }
    
    func headerView(color: String) -> some View {
        return Rectangle().fill(Color.white)
            .overlay(Rectangle().fill(Color(color)).frame(height: 4).padding(.horizontal))
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    func versRow(vers: FavoriteVers, color: String) -> some View {        
        return HStack(spacing: 20) {
            Circle().fill(Color(color)).frame(width: 24)
            VStack(alignment: .leading) {
                HStack {
                    Text(vers.szep)
                        .font(.medium16)
                    Spacer()
                    Text(vers.translation)
                        .font(.regular14)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 5)

                Text(vers.szoveg)
                    .font(.light16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contextMenu(menuItems: {
            Button(action: {
                jumpToVers(vers: vers)
            }) {
                Label("Ugrás a szöveghez", systemImage: "arrow.uturn.up")
            }
            Button(action: {
                store.deleteFavourite(color: color, vers: vers)
            }) {
                Label("Törlés", systemImage: "trash")
            }
        })
        
    }
    
    func jumpToVers(vers: FavoriteVers) {
        print(vers)
        selectedTab = 1
        store.jumpToVers(vers: vers)
    }

    
    func favourites(color: String) -> [FavoriteVers] {
        favouritesDictionary[color] ?? []
    }
}



//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView(selectedTab: .constant(3))
//    }
//}
