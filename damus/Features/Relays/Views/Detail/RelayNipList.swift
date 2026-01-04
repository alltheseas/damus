//
//  RelayNipList.swift
//  damus
//
//  Created by eric on 4/1/24.
//

import SwiftUI

struct NIPNumber: View {
    let character: String
    
    var body: some View {
        NIPIcon {
            Text(verbatim: character)
                .font(.title3.bold())
                .mask(Text(verbatim: character)
                    .font(.title3.bold()))
        }
    }
}

struct NIPIcon<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(DamusColors.neutral3)
                .frame(width: 40, height: 40)
            
            content
                .foregroundStyle(DamusColors.mediumGrey)
        }
    }
}

struct RelayNipList: View {
    
    let nips: [Int]
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Supported NIPs", comment: "Label to display relay's supported NIPs.")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(DamusColors.mediumGrey)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(nips, id:\.self) { nip in
                        if let link = NIPURLBuilder.url(forNIP: nip) {
                            let nipString = NIPURLBuilder.formatNipNumber(nip: nip)
                            Button(action: {
                                openURL(link)
                            }) {
                                NIPNumber(character: "\(nipString)")
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
            .scrollIndicatorsHiddenCompat()
        }
    }
}

// MARK: - iOS 15 Compatibility

private extension View {
    /// Applies .scrollIndicators(.hidden) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func scrollIndicatorsHiddenCompat() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollIndicators(.hidden)
        } else {
            self
        }
    }
}

struct RelayNipList_Previews: PreviewProvider {
    static var previews: some View {
        RelayNipList(nips: [0, 1, 2, 3, 4, 11, 15, 50])
    }
}
