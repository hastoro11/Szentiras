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
    @State var selectedBook: CDBook?
    
    var columns = [GridItem(.adaptive(minimum: 52, maximum: 56), spacing: 10)]
    
    var body: some View {
        VStack {
            Header(selectedBook: selectedBook, showTranslationSheet: $showTranslationSheet, showSettings: .constant(false), selectedTab: $selectedTab, readingView: false)
            if store.isLoading {
                Spacer()
                ProgressView("Keresés...")
            } else {
                ScrollView(showsIndicators: false) {
                    Text("Ószövetség")
                        .font(.light18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    bookList(books: store.allBooks.filter({$0.number < 200}))
                    Text("Újszövetség")
                        .font(.light18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    bookList(books: store.allBooks.filter({$0.number > 200}))
                }
                .sheet(item: $selectedBook) { book in
                    BookChapterView(book: book, selectedTab: $selectedTab)
                        .environmentObject(store)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: 756)
    }
    
    func bookList(books: [CDBook]) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(books) { book in
                Button(action: {
                    selectedBook = book
                }) {
                    IconButton(title: book.abbrev, size: 54, color: book.number < 200 ? .colorGreen : .colorBlue)
                }
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(selectedTab: .constant(1))
//            .environmentObject(BibliaStore(translation: .RUF))
    }
}
