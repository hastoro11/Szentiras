//
//  BookView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct BookView: View {
    @EnvironmentObject var store: BibliaStore
    @Binding var selectedTab: Int
    @State var showTranslationSheet = false    
    @State var selectedBook: Book?
    
    var columns = [GridItem(.adaptive(minimum: 52, maximum: 56), spacing: 10)]
    
    var body: some View {
        VStack {
            HStack {
                IconButton(title: store.currentBook.abbreviation, icon: nil, size: 44, color: .dark)
                Button(action: {
                    selectedBook = store.currentBook
                }, label: {
                    IconButton(title: String(store.currentChapter), icon: nil, size: 44, color: .colorYellow)
                })
                
                Spacer()
                Text(store.biblia.shortName)
                    .font(.medium16)
                Spacer()
                Color.clear
                    .frame(width: 44, height: 44)
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
            .sheet(item: $selectedBook) { book in
                BookChapterView(book: book, selectedTab: $selectedTab)
                    .environmentObject(store)
            }
            
        }
        .padding(.horizontal)
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
                Button(action: {
                    selectedBook = book
                }) {
                    IconButton(title: book.abbreviation, size: 54, color: book.covenant == .old ? .colorGreen : .colorBlue)
                }
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(selectedTab: .constant(1))
            .environmentObject(BibliaStore(biblia: .init(with: .RUF)))
    }
}
