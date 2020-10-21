//
//  AddEditNotesView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 23..
//

import SwiftUI

struct AddEditNotesView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: BibliaStore
    var vers: CDVers
    @State var notes: String
    @Binding var selectedTab: Int
    init(vers: CDVers, selectedTab: Binding<Int>) {
        self.vers = vers
        _notes = State(wrappedValue: vers.notes)
        _selectedTab = selectedTab
    }
    var color: Color {
        switch vers.translation {
        case "RUF":
            return .colorYellow
        case "KG":
            return .colorRed
        case "KNB":
            return .colorGreen
        case "SZIT":
            return .colorBlue
        default:
            return .clear
        }
    }
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
                Circle().fill(color)
                    .frame(width: .smallCircle, height: .smallCircle)
                Text(vers.szep)
                    .font(.medium14)
                Spacer()
                Button(action: gotoSelectedVers) {
                    Image(systemName: "chevron.right")
                        .frame(width: .smallCircle, height: .smallCircle)
                        .background(Circle().fill(color))
                        .foregroundColor(.white)
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            Text(vers.szoveg)
                .font(.light18)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextEditor(text: $notes)
                .font(.light20)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.dark, lineWidth: 0.5))
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            
            Button(action: {
                vers.saveNotes(notes: notes, context: context)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Mentés")
                    .font(.medium16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(RoundedRectangle(cornerRadius: 12).fill(color))
            })
            .accentColor(.white)
            .padding()
        }
        .frame(maxWidth: 756)
        .navigationBarHidden(true)
    }
    
    func gotoSelectedVers() {
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            selectedTab = 1
            if let book = CDBook.fetchBookByAbbrev(abbrev: vers.book, context: context) {
                store.currentBook = book
                store.translation = Translation(rawValue: vers.translation) ?? .RUF
                store.currentChapter = vers.chapter
                store.scrollToTarget = vers.gepi
            }
        }
    }
}

//struct AddEditNotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            AddEditNotesView()
//        }
//    }
//}
