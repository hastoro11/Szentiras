//
//  ReadingView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct ReadingView: View {
    @EnvironmentObject var store: BibliaStore
    @ObservedObject var viewModel = ReadingViewModel()
    @Binding var selectedTab: Int
    @State var showTranslationSheet = false
    @State var showSettings = false
    @State var selectedBook: Book?
    @State var hideHeader = false
    
    var maxNumberOfVerses: Int {
        store.results.map({$0.valasz.versek.count}).max() ?? 0
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if !hideHeader {
                    Header(selectedBook: selectedBook, showTranslationSheet: $showTranslationSheet, showSettings: $showSettings, selectedTab: $selectedTab, noReadingOption: false, readingView: true)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
                if store.isLoading {
                    ProgressView("Keresés...")
                } else {
                    bookChapterTabview
                }
                Spacer()
            }
            .padding(.horizontal)
            .zIndex(0)
            
            
            if showSettings {
                settingsView
                    
            } // end VStack
        } // end ZStack
        .alert(item: $store.error) { (error) -> Alert in
            Alert(title: Text("Hiba"), message: Text(error.description), dismissButton: .default(Text("OK")))
        }
        
        .onAppear {
            store.fetchBook(book: store.currentBook)
        }
    }
    
    var bookChapterTabview: some View {
        TabView(selection: $store.currentChapter) {
            ForEach(store.results) { result in
                ChapterView(result: result, maxNumberOfVerses: maxNumberOfVerses)
                    .environmentObject(viewModel)
                    .tag(chapterFromResult(result: result))
            }
            
        }.tabViewStyle(PageTabViewStyle())
        .onTapGesture {
            withAnimation(.spring()) {
                hideHeader.toggle()
            }
        }
    }
    
    var settingsView: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Text("Betűnagyság")
                    .font(.medium16)
                Slider(value: $viewModel.fontSize, in: 0...3, step: 1)
                .padding(.horizontal)
            }
            .padding(.bottom)
            HStack {
                Text("Versszámozás")
                    .font(.medium16)
                Toggle("", isOn: $viewModel.showIndex)
                    .padding(.horizontal)
            }
            .padding(.bottom)
            HStack {
                Text("Folyamatos olvasás")
                    .font(.medium16)
                Toggle("", isOn: $viewModel.continous)
                    .padding(.horizontal)
            }
            .padding(.bottom)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(maxHeight: 200)
        .background(Color.white.edgesIgnoringSafeArea(.bottom).shadow(radius: 5))
        .zIndex(10)
        .transition(.move(edge: .bottom))
        .animation(.spring())
    }
    
    func chapterFromResult(result: Result) -> Int {
        let hivatkozas = result.keres.hivatkozas
        let arr = hivatkozas.split(separator: " ")
        return Int(arr[1]) ?? 1
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView(selectedTab: .constant(0))
            .environmentObject(BibliaStore(biblia: .init(with: .RUF)))
    }
}
