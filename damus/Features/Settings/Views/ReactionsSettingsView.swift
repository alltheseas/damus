//
//  ReactionsSettingsView.swift
//  damus
//
//  Created by Suhail Saqan on 7/3/23.
//

import SwiftUI
import EmojiPicker
import EmojiKit

// MARK: - iOS 15 Compatibility

/// ViewModifier for medium/large presentation detents on iOS 16+, no-op on iOS 15.
private struct EmojiPickerSheetModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.presentationDetents([.medium, .large])
        } else {
            content
        }
    }
}

struct ReactionsSettingsView: View {
    @ObservedObject var settings: UserSettingsStore
    let damus_state: DamusState
    @State private var isReactionsVisible: Bool = false

    @State private var selectedEmoji: Emoji? = nil

    var body: some View {
        Form {
            Section {
                Text(settings.default_emoji_reaction)
                    .onTapGesture {
                        isReactionsVisible = true
                    }
            } header: {
                Text("Select default emoji", comment: "Prompt selection of user's default emoji reaction")
            }
        }
        .navigationTitle(NSLocalizedString("Reactions", comment: "Title of emoji reactions view"))
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $isReactionsVisible) {
            NavigationView {
                EmojiPickerView(selectedEmoji: $selectedEmoji, emojiProvider: damus_state.emoji_provider)
            }
            .modifier(EmojiPickerSheetModifier())
        }
        .onChange(of: selectedEmoji) { newEmoji in
            guard let newEmoji else {
                return
            }
            settings.default_emoji_reaction = newEmoji.value
        }
    }
}

struct ReactionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionsSettingsView(settings: UserSettingsStore(), damus_state: test_damus_state)
    }
}
