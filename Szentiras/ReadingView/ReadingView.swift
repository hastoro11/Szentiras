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
    @State var selectedBook: CDBook?
    @State var hideHeader = false
    
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

    }
    
    var bookChapterTabview: some View {
        let numberOfChaptersInCurrentBook = numberOfChaptersInBookByNumber[store.currentBook!.number, default: 1]
        return TabView(selection: $store.currentChapter) {
            ForEach(1...numberOfChaptersInCurrentBook, id:\.self) { chapter in
                ChapterView(verses: store.allVersesInABook.filter({$0.chapter == chapter}))
                    .tag(chapter)
                    .environmentObject(viewModel)
            }
        }
        .tabViewStyle(PageTabViewStyle())
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

//struct ReadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadingView(selectedTab: .constant(0))
//            .environmentObject(BibliaStore(translation: .RUF))
//    }
//}
