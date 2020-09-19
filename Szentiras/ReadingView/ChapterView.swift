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
    var bookTitle: String {
        let book = store.currentBook
        return book?.name ?? ""
    }
    var body: some View {        
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
                    continousText()
                }
                
                if !viewModel.continous {
                    notContinuous()
                        .lineSpacing(6)
                }
            }
        }
    }   

    @ViewBuilder
    func notContinuous() -> some View {
        Group {
            if viewModel.showIndex {
                ForEach(verses) { vers in
                    Group {
                        Text("\(vers.index) ").font(viewModel.indexSize)
                            + Text(vers.szoveg.strippedHTMLElements).font(viewModel.textSize)
                    }
                    .lineSpacing(6)
                    .onLongPressGesture {
                        highlightedVers = vers
                    }
                }
            } else {
                ForEach(verses) { vers in
                    Text(vers.szoveg.strippedHTMLElements).font(viewModel.textSize).lineSpacing(6)
                }
            }
        }
    }

    func continousText() -> some View {
        let versek = verses.reduce("") { (result, vers) in
            result + (vers.szoveg.strippedHTMLElements) + " "
        }
        var text = Text("")
        for vers in verses {
            text = text + Text("\(vers.index) ").font(viewModel.indexSize)
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
