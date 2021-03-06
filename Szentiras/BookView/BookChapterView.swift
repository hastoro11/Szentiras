//
//  BookChapterView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct BookChapterView: View {
    @EnvironmentObject var store: BibliaStore
    @Environment(\.presentationMode) var presentationMode
    var book: CDBook
    var chapterNumbers: Int {
        numberOfChaptersInBookByNumber[book.number]!
    }
    @Binding var selectedTab: Int
    var columns = [GridItem(.adaptive(minimum: 52, maximum: 56), spacing: 10)]
    var body: some View {
        VStack {
            Text(book.name)
                .font(.medium18)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(1...chapterNumbers, id:\.self) { ch in
                        Button(action: {
                            store.currentBook = book
                            store.currentChapter = ch                            
                            selectedTab = 1
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            IconButton(title: "\(ch)", icon: nil, size: 54, color: book.number < 200 ? .colorGreen : .colorBlue)
                        })
                    }
                }
                Spacer()
            }
        }.padding()
    }
}
//
//struct BookChapterView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookChapterView(book: Biblia(with: .RUF).books[40], selectedTab: .constant(1))
//    }
//}
