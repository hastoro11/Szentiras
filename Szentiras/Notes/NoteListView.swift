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
                            .font(.light18)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(verses.filter({!$0.notes.isEmpty})) { vers in
                            NoteRow(vers: vers, selectedTab: $selectedTab)
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


struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView(selectedTab: .constant(2))
    }
}
