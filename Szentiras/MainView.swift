//
//  MainView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: BibliaStore
    var body: some View {
        if store.isFirstLoading {
            Text("First loading...")
        } else {
            AppTabView()
        }
            
    }    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
