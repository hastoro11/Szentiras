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
                Spacer()
                Text("Kedvencek")
                    .font(.medium16)
                Spacer()
            }
            
            if emptyDictionary {
                Divider()
                Spacer()
                Text("Nincsenek még kedvencek")
                    .font(.light18)
                Spacer()
            } else {
                List {
                    ForEach(keys, id:\.self) { color in
                        if !favourites(color: color).isEmpty {
                            Section(header: headerView(color: color)) {
                                ForEach(favourites(color: color)) { fav in
                                    versRow(vers: fav, color: color)
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
        HStack(spacing: 20) {
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
        
        
    }

    
    func favourites(color: String) -> [FavoriteVers] {
        favouritesDictionary[color] ?? []
    }
}



struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(selectedTab: .constant(3))
    }
}
