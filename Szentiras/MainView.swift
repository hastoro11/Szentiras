//
//  MainView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var store = BibliaStore()
    var body: some View {
        AppTabView()
            .environmentObject(store)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
