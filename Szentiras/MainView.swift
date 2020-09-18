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
    var body: some View {
        if count != 0 {
            SplashView()
                .onAppear {
                    cancellable = timerPublisher.sink(receiveValue: {_ in
                        count = max(count-1, 0)
                        if count == 0 {
                            cancellable?.cancel()
                        }
                    })
                    
                }
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
