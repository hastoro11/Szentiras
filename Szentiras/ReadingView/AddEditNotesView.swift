//
//  AddEditNotesView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 23..
//

import SwiftUI

struct AddEditNotesView: View {
    @Environment(\.presentationMode) var presentationMode
//    var vers: CDVers
    @State var notes: String = ""
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                .accentColor(.dark)
                Spacer()
                Text("Jegyzetek")
                Spacer()
            }
            .font(.medium18)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            Divider()
            HStack {
                Circle().fill(Color.colorRed)
                    .frame(width: .smallCircle, height: .smallCircle)
                Text("1Móz 13, 1")
                    .font(.medium14)
                Spacer()
                
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            TextEditor(text: $notes)
                .font(.light20)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.dark, lineWidth: 0.5))
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Mentés")
                    .font(.medium16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.colorRed))
            })
            .accentColor(.white)
            .padding()
        }
        .navigationBarHidden(true)
    }
}

struct AddEditNotesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEditNotesView()
        }
    }
}
