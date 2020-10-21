//
//  ReadingView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct ReadingView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var store: BibliaStore
    
    @ObservedObject var viewModel = ReadingViewModel()
    
    @Binding var selectedTab: Int
    
    @State var showTranslationSheet = false
    @State var showSettings = false
    @State var selectedBook: CDBook?
    @State var hideHeader = false
    @State var highlightedVers: CDVers?

    var body: some View {        
        NavigationView {
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
                            .frame(maxWidth: 756)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .zIndex(0)
                // end VStack
                if showSettings {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showSettings = false
                            }
                        }                        
                        .zIndex(5)
                }

                if showSettings {
                    settingsView
                }
                
                if highlightedVers != nil {
                    highlightedVersView(highlightedVers!)
                }
            } // end ZStack
            .alert(item: $store.error) { (error) -> Alert in
                Alert(title: Text("Hiba‼️"), message: Text(error.description), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true)            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func highlightedVersView(_ vers: CDVers) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(highlightedVers!.szep)
                    .font(.medium14)
                Spacer()
                Image(systemName: "xmark")
                    .font(.medium14)
                    .onTapGesture {
                        highlightedVers = nil
                    }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16))
            Divider()
                .background(Color.dark)
                .padding(.horizontal)
            
            Text("Kiemelés")
                .font(.medium14)
                .padding(.leading)
            HStack(spacing: 10) {
                ForEach(["Red", "Blue", "Yellow", "Green"], id:\.self) { color in
                    Button(action: {
                        vers.setMarking(color: color, context: context)
                        store.addFavourite(vers: vers)
                        highlightedVers = nil
                    }) {
                        Circle().fill(Color(color)).frame(width: .bigCircle, height: .bigCircle)
                    }
                }
                Button(action: {
                    store.deleteFavourite(vers: vers)
                    vers.deleteMarking(context: context)
                    highlightedVers = nil
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: .bigCircle, weight: .thin))
                        .foregroundColor(.black)
                }                
            }
            .padding()
            
            NavigationLink(
                destination: AddEditNotesView(vers: highlightedVers!, selectedTab: $selectedTab),
                label: {
                    Text("Jegyzetek")
                        .font(.medium16)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.dark, lineWidth: 0.5))
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: 756)
        .frame(height: 250)
        .background(Color.white.edgesIgnoringSafeArea(.bottom).shadow(radius: 5))
        .zIndex(9)
        .transition(.move(edge: .bottom))
        .animation(.spring())
        
    }
    
    var bookChapterTabview: some View {
        let numberOfChaptersInCurrentBook = numberOfChaptersInBookByNumber[store.currentBook!.number, default: 1]
        return TabView(selection: $store.currentChapter) {
            ForEach(1...numberOfChaptersInCurrentBook, id:\.self) { chapter in
                ChapterView(verses: store.allVersesInABook.filter({$0.chapter == chapter}), highlightedVers: $highlightedVers, hideHeader: $hideHeader)
                    .tag(chapter)
                    .environmentObject(viewModel)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    var settingsView: some View {
        VStack(alignment: .leading) {
            VStack {
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
            .frame(maxWidth: 756)
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

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
