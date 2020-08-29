//
//  BookView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct BookView: View {
    @EnvironmentObject var store: BibliaStore
    @State var showTranslationSheet = false
    var columns = [GridItem(.adaptive(minimum: 52, maximum: 56), spacing: 10)]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(store.biblia.shortName)
                    .font(.medium16)
                Spacer()
                Button(action: {
                    showTranslationSheet.toggle()
                }, label: {
                    IconButton(icon: "bubble.left.and.bubble.right", size: 44, color: .colorRed)
                })
                .actionSheet(isPresented: $showTranslationSheet, content: {
                    actionSheet
                })
            }
            ScrollView(showsIndicators: false) {
                Text("Ószövetség")
                    .font(.light18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                bookList(books: store.biblia.books.filter({$0.covenant == .old}))
                Text("Újszövetség")
                    .font(.light18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                bookList(books: store.biblia.books.filter({$0.covenant == .new}))
            }
            
        }
        .padding()
    }
    
    var actionSheet: ActionSheet {
        let translations = Translation.allCases
        return ActionSheet(
            title: Text("Válassz fordítást"),
            message: Text(""),
            buttons: [
                .default(Text(translations[0].shortName), action: {store.changeTranslation(to: translations[0])}),
                .default(Text(translations[1].shortName), action: {store.changeTranslation(to: translations[1])}),
                .default(Text(translations[2].shortName), action: {store.changeTranslation(to: translations[2])}),
                .default(Text(translations[3].shortName), action: {store.changeTranslation(to: translations[3])}),
                .cancel(Text("Mégsem"))
            ])
        
    }
    
    func bookList(books: [Book]) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(books) { book in                
                IconButton(title: book.abbreviation, size: 54, color: book.covenant == .old ? .colorGreen : .colorBlue)
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
            .environmentObject(BibliaStore())
    }
}
