//
//  NoteListView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 26..
//

import SwiftUI

struct NoteListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: CDVers.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \CDVers.timestamp, ascending: false)],
                  predicate: NSPredicate(format: "notes_ != nil"),
                  animation: nil) var verses: FetchedResults<CDVers>
    @Binding var selectedTab: Int
    var body: some View {
        NavigationView {
            VStack {
                Text("Jegyzetek")
                    .font(.medium16)
                Divider()
                if verses.count == 0 {
                    VStack {
                        Spacer()
                        Text("Nincsenek még jegyzetek")
                            .font(.light20)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(verses.filter({!$0.notes.isEmpty})) { vers in
                            NoteRow(vers: vers)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                }
                
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                
            }
        }
    }
    
    func delete(indexSet: IndexSet) {
        for i in indexSet {
            verses[i].deleteNotes(context: context)
        }
    }
}

struct NoteRow: View {
    @ObservedObject var vers: CDVers
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
        NavigationLink(
            destination: AddEditNotesView(vers: vers)) {
            VStack {
                HStack(spacing: 20) {
                    Text(vers.translation)
                        .foregroundColor(.white)
                        .frame(width: .bigCircle, height: .bigCircle)
                        .background(Circle().fill(color))
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vers.szep)
                                .font(.medium16)
                            Spacer()
                            Text(vers.timestamp?.stringFormat ?? "")
                                .font(.regular14)
                                .foregroundColor(.gray)
                        }
                        Text(vers.notes)
                            .font(.light18)
                            .lineLimit(2)
                        Spacer()
                    }
                }
                Spacer()
            }
            .frame(height: 85)
        }
        .listRowBackground(Color.white)
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(selectedTab: .constant(2))
    }
}
