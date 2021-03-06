//
//  Header.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 30..
//

import SwiftUI

struct Header: View {
    @EnvironmentObject var store: BibliaStore
    @State var selectedBook: CDBook?
    @Binding var showTranslationSheet: Bool
    @Binding var showSettings: Bool
    @Binding var selectedTab: Int
    var noReadingOption: Bool = true
    var readingView: Bool
    enum SlideSheet {
        case translation, settings
    }
    func toggleSlideSheets(menu: SlideSheet) {
        withAnimation {
            if menu == .settings {
                showSettings.toggle()
                if showSettings {
                    showTranslationSheet = false
                }
            } else {
                showTranslationSheet.toggle()
                if showTranslationSheet {
                    showSettings = false
                }
            }
        }
    }
    var body: some View {
        HStack {
            Button(action: {
                selectedTab = 0
            }, label: {
                IconButton(title: store.currentBook?.abbrev, icon: nil, size: 44, color: .dark)
            })
            Button(action: {
                selectedBook = store.currentBook                
            }, label: {
                IconButton(title: String(store.currentChapter), icon: nil, size: 44, color: .colorYellow)
            })
            .opacity(readingView ? 1 : 0)
            .sheet(item: $selectedBook) { book in
                BookChapterView(book: book, selectedTab: $selectedTab)
            }
            Spacer()
            Text(store.translation.shortName)
                .font(.medium16)
            Spacer()
            Button(action: {
//                showSettings.toggle()
                toggleSlideSheets(menu: .settings)
            }, label: {
                IconButton(icon: "textformat", size: 44, color: .colorGreen)
            })
            .opacity(noReadingOption ? 0.0 : 1.0)
            Button(action: {
//                showTranslationSheet.toggle()
                toggleSlideSheets(menu: .translation)
            }, label: {
                IconButton(icon: "bubble.left.and.bubble.right", size: 44, color: .colorRed)
            })
            .actionSheet(isPresented: $showTranslationSheet, content: {
                ActionSheet.translationActionSheet(store: store, readingView: readingView)
            })
        }
    }
}
