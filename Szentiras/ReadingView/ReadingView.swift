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
    @State var showTranslationSheet = false
    @State var showSettings = false
    @State var hideHeader = false
    
    var maxNumberOfVerses: Int {
        store.results.map({$0.valasz.versek.count}).max() ?? 0
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if !hideHeader {
                    HStack {
                        IconButton(title: store.currentBook.abbreviation, icon: nil, size: 44, color: .dark)
                        IconButton(title: String(store.currentChapter), icon: nil, size: 44, color: .colorYellow)
                        Spacer()
                        Text(store.biblia.shortName)
                            .font(.medium16)
                        Spacer()
                        Button(action: {
                            showSettings.toggle()
                        }, label: {
                            IconButton(icon: "textformat", size: 44, color: .colorGreen)
                        })
                        
                        
                        Button(action: {
                            showTranslationSheet.toggle()
                        }, label: {
                            IconButton(icon: "bubble.left.and.bubble.right", size: 44, color: .colorRed)
                        })
                        .actionSheet(isPresented: $showTranslationSheet, content: {
                            actionSheet
                        })
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    
                }
                Spacer()
                if store.isLoading {
                    ProgressView("Keresés...")
                } else {
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
                Spacer()
            }
            .padding(.horizontal)
            .zIndex(0)
            
            if showSettings {
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
            } // end VStack
        } // end ZStack
        
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
    
    func chapterFromResult(result: Result) -> Int {
        let hivatkozas = result.keres.hivatkozas
        let arr = hivatkozas.split(separator: " ")
        return Int(arr[1]) ?? 1
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView()
            .environmentObject(BibliaStore(biblia: .init(with: .RUF)))
    }
}
