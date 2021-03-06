//
//  ChapterView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct ChapterView: View {
    @EnvironmentObject var viewModel: ReadingViewModel
    @EnvironmentObject var store: BibliaStore
    var verses: [CDVers]
    @Binding var highlightedVers: CDVers?
    @Binding var hideHeader: Bool
    var bookTitle: String { store.currentBook?.name ?? "" }

    var body: some View {
        ScrollViewReader { reader in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 6) {
                    VStack {
                        Text(bookTitle)
                            .font(.bold26)
                            .multilineTextAlignment(.center)
                        Text("\(store.currentChapter). fejezet")
                            .font(.medium22)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    if viewModel.continous {
                        continousText(reader: reader)
                    }
                    
                    if !viewModel.continous {
                        notContinuous(reader: reader)
                            .lineSpacing(6)
                    }
                }
            }
            .onChange(of: store.scrollToTarget) { gepi in
                if let gepi = gepi {
                    withAnimation(.easeInOut){
                        reader.scrollTo(gepi, anchor: .top)
                    }
                }
            }
        }
    }   

    @ViewBuilder
    func notContinuous(reader: ScrollViewProxy) -> some View {
        Group {
            if viewModel.showIndex {
                    ForEach(verses) { vers in
                        versRow(vers: vers)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(vers.marking.opacity(0.3))
                            .background(highlightedVers == vers ? Color.black.opacity(0.2) : Color.clear)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    hideHeader.toggle()
                                }
                            }
                            .onLongPressGesture {
                                highlightedVers = vers
                                withAnimation(.easeInOut) {
                                    reader.scrollTo(vers.gepi, anchor: .top)
                                }
                            }
                    }
            } else {
                ForEach(verses) { vers in
                    Text(vers.szoveg.strippedHTMLElements).font(viewModel.textSize).lineSpacing(6)
                }
            }
        }
    }
    
    func versRow(vers: CDVers) -> some View {
        return Group {
            Text("\(vers.index) " + (vers.notes.isEmpty ? "" : "*")).font(viewModel.indexSize)
                + Text(vers.szoveg.strippedHTMLElements).font(viewModel.textSize)
        }
        .id(vers.gepi)
        .lineSpacing(6)
        
    }

    func continousText(reader: ScrollViewProxy) -> some View {
        let versek = verses.reduce("") { (result, vers) in
            result + (vers.szoveg.strippedHTMLElements) + " "
        }
        var text = Text("")
        for vers in verses {
            text = text + Text("\(vers.index) " + (vers.notes.isEmpty ? "" : "*")).font(viewModel.indexSize)
            text = text + Text(vers.szoveg.strippedHTMLElements).font(viewModel.textSize) + Text(" ")
        }
        return Group {
            if !viewModel.showIndex {
                Text(versek)
                    .font(viewModel.textSize)
                    .lineSpacing(6)
            }
            if viewModel.showIndex {
                text.lineSpacing(6)
            }
        }
        
    }
}

//struct ChapterView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChapterView(result: result1, maxNumberOfVerses: result1.valasz.versek.count)
//            .environmentObject(ReadingViewModel())
//    }
//}
