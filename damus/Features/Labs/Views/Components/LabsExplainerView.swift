//
//  LabsExplainerView.swift
//  damus
//
//  Created by eric on 11/6/25.
//

import SwiftUI

/// ViewModifier to apply presentation detents and drag indicator on iOS 16+, with no-op fallback for iOS 15.
private struct LabsExplainerSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])
        } else {
            content
        }
    }
}

struct LabsExplainerView: View {
    let labName: String
    let systemImage: String
    let labDescription: String
    
    var body: some View {
        PurpleBackdrop {
            VStack(alignment: .center) {
                HStack {
                    Image(systemName: systemImage)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                    Text(labName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(NSLocalizedString(labDescription, comment: "Description of the feature."))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
        }
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(DamusColors.purple), alignment: .top)
        .modifier(LabsExplainerSheetModifier())
    }
}
