//
//  SplashView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 18..
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Szentírás")
                    .font(.bold36)
                    .padding(.bottom, 36)
                ProgressView("Keresés...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Spacer()
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.colorBlue)
                        
            Image("Pattern")
                .resizable()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
