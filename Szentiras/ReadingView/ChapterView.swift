//
//  ChapterView.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 08. 29..
//

import SwiftUI

struct ChapterView: View {
    var result: Result
    @EnvironmentObject var viewModel: ReadingViewModel
    var maxNumberOfVerses: Int
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 6) {
                if viewModel.continous {
                    continousText()
                }
                
                if !viewModel.continous {
                    notContinuous()
                }
            }
        }
    }
    
    @ViewBuilder
    func notContinuous() -> some View {
        Group {
            if viewModel.showIndex {
                ForEach(0..<maxNumberOfVerses, id:\.self) { v in
                    if v < result.valasz.versek.count {
                        Group {
                            Text("\(v+1) ").font(viewModel.indexSize)
                                + Text(result.valasz.versek[v].szoveg?.strippedHTMLElements ?? "").font(viewModel.textSize)
                        }
                        .lineSpacing(6)
                    }
                }
            } else {
                ForEach(1...maxNumberOfVerses, id:\.self) { v in
                    if v < result.valasz.versek.count {
                        Text(result.valasz.versek[v].szoveg?.strippedHTMLElements ?? "").font(viewModel.textSize).lineSpacing(6)
                    }
                }
            }
        }
    }
    
    func continousText() -> some View {
        let versek = result.valasz.versek.reduce("") { (result, vers) in
            result + (vers.szoveg?.strippedHTMLElements ?? "") + " "
        }
        var text = Text("")
        for index in result.valasz.versek.indices {
            text = text + Text("\(index+1) ").font(viewModel.indexSize)
            text = text + Text(result.valasz.versek[index].szoveg?.strippedHTMLElements ?? "").font(viewModel.textSize) + Text(" ")
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

struct ChapterView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterView(result: result1, maxNumberOfVerses: result1.valasz.versek.count)
            .environmentObject(ReadingViewModel())
    }
}
