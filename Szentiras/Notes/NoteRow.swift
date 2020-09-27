//
//  NoteRow.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2020. 09. 26..
//

import SwiftUI
import Combine

struct NoteRow: View {
    @ObservedObject var vers: CDVers
    @Binding var selectedTab: Int
    var color: Color {
        switch vers.translation {
        case "RUF":
            return .colorYellow
        case "KG":
            return .colorRed
        case "KNB":
            return .colorGreen
        case "SZIT":
            return .colorBlue
        default:
            return .clear
        }
    }
    var timer = Timer.publish(every: 10, on: RunLoop.main, in: .default).autoconnect()
    @State var cancellable: AnyCancellable?
    var body: some View {
        NavigationLink(
            destination: AddEditNotesView(vers: vers, selectedTab: $selectedTab)) {
            VStack {
                HStack(spacing: 20) {
                    Text(vers.translation)
                        .foregroundColor(.white)
                        .frame(width: .bigCircle, height: .bigCircle)
                        .background(Circle().fill(color))
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vers.szep)
                                .font(.medium16)
                            Spacer()
                            Text(vers.timestamp?.stringFormat ?? "")
                                .font(.regular14)
                                .foregroundColor(.gray)
                        }
                        Text(vers.notes)
                            .font(.light18)
                            .lineLimit(2)
                        Spacer()
                    }
                }
                Spacer()
            }
            .frame(height: 85)
        }
        .onAppear {
            vers.objectWillChange.send()
            cancellable = timer.sink(receiveValue: {_ in
                vers.objectWillChange.send()
            })
        }
        .onDisappear {
            cancellable?.cancel()
            cancellable = nil
        }
    }
}
//
//
//struct NoteRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteRow()
//    }
//}
