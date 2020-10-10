//
//  MainView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI
import Combine

struct MainView: View {    
    var timerPublisher = Timer.publish(every: 1, on: RunLoop.main, in: .default).autoconnect()
    @State var cancellable: AnyCancellable?
    @State var count = 2
    @EnvironmentObject var store: BibliaStore
    var body: some View {
        if !store.booksLoaded {
            SplashView()                
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
