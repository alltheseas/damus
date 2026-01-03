//
//  iOS15Compatibility.swift
//  damus
//
//  Provides iOS 15 compatibility shims for iOS 16+ SwiftUI modifiers.
//  These extensions conditionally apply modifiers only when running on iOS 16+,
//  silently becoming no-ops on iOS 15.
//

import SwiftUI

// MARK: - Presentation Detent Helpers

extension View {
    /// Applies .presentationDetents([.medium]) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func presentationDetentsMedium() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.medium])
        } else {
            self
        }
    }

    /// Applies .presentationDetents([.large]) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func presentationDetentsLarge() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.large])
        } else {
            self
        }
    }

    /// Applies .presentationDetents([.medium, .large]) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func presentationDetentsMediumLarge() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.medium, .large])
        } else {
            self
        }
    }

    /// Applies .presentationDetents([.height(height)]) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func presentationDetentsHeight(_ height: CGFloat) -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.height(height)])
        } else {
            self
        }
    }

    /// Applies .presentationDragIndicator(.visible) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func presentationDragIndicatorVisible() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDragIndicator(.visible)
        } else {
            self
        }
    }
}

// MARK: - Scroll Modifier Helpers

extension View {
    /// Applies .scrollDismissesKeyboard(.immediately) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func scrollDismissesKeyboardImmediately() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollDismissesKeyboard(.immediately)
        } else {
            self
        }
    }

    /// Applies .scrollDismissesKeyboard(.interactively) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func scrollDismissesKeyboardInteractively() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollDismissesKeyboard(.interactively)
        } else {
            self
        }
    }

    /// Applies .scrollIndicators(.hidden) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func scrollIndicatorsHidden() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollIndicators(.hidden)
        } else {
            self
        }
    }

    /// Applies .scrollIndicators(.never) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func scrollIndicatorsNever() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollIndicators(.never)
        } else {
            self
        }
    }
}

// MARK: - Toolbar Helpers

extension View {
    /// Applies .toolbarBackground(.hidden) on iOS 16+, no-op on iOS 15.
    @ViewBuilder
    func toolbarBackgroundHidden() -> some View {
        if #available(iOS 16.0, *) {
            self.toolbarBackground(.hidden)
        } else {
            self
        }
    }
}
