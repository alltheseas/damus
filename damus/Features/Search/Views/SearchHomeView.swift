//
//  SearchHomeView.swift
//  damus
//
//  Created by William Casarin on 2022-05-19.
//

import SwiftUI
import CryptoKit
import NaturalLanguage

struct SearchHomeView: View {
    let damus_state: DamusState
    @StateObject var model: SearchHomeModel
    @State var search: String = ""
    @FocusState private var isFocused: Bool
    @State var loadingTask: Task<Void, Never>?

    func content_filter(_ fstate: FilterState) -> ((NostrEvent) -> Bool) {
        var filters = ContentFilters.defaults(damus_state: damus_state)
        filters.append(fstate.filter)
        return ContentFilters(filters: filters).filter
    }

    var SearchInput: some View {
        HStack {
            HStack{
                Image("search")
                    .foregroundColor(.gray)
                TextField(NSLocalizedString("Search...", comment: "Placeholder text to prompt entry of search query."), text: $search)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
            }
            .padding(10)
            .background(.secondary.opacity(0.2))
            .cornerRadius(20)
            
            if(!search.isEmpty) {
                Text("Cancel", comment: "Cancel out of search view.")
                    .foregroundColor(.accentColor)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 10.0))
                    .onTapGesture {
                        self.search = ""
                        isFocused = false
                    }
            }
        }
    }
    
    var VinePOCEntryPoint: some View {
        NavigationLink {
            VinePOCView(damus_state: damus_state)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "play.rectangle.on.rectangle")
                    .foregroundColor(.purple)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Open Vine POC")
                        .font(.callout)
                        .bold()
                    Text("Preview looping videos from relay.divine.video")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color.secondary.opacity(0.15))
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }
    
    var GlobalContent: some View {
        return TimelineView<AnyView>(
            events: model.events,
            loading: $model.loading,
            damus: damus_state,
            show_friend_icon: true,
            filter: content_filter(FilterState.posts),
            content: {
                AnyView(VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundStyle(PinkGradient)
                        Text("Follow Packs", comment: "A label indicating that the items below it are follow packs")
                            .foregroundStyle(PinkGradient)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    FollowPackTimelineView<AnyView>(events: model.followPackEvents, loading: $model.loading, damus: damus_state, show_friend_icon: true, filter: content_filter(FilterState.follow_list)
                    ).padding(.bottom)
                    
                    Divider()
                        .frame(height: 1)
                    
                    HStack {
                        Image("notes.fill")
                        Text("All recent notes", comment: "A label indicating that the notes being displayed below it are all recent notes")
                        Spacer()
                    }
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .padding(.horizontal)
                }.padding(.bottom, 50))
            }
        )
    }
    
    var SearchContent: some View {
        SearchResultsView(damus_state: damus_state, search: $search)
    }
    
    var MainContent: some View {
        Group {
            if search.isEmpty {
                GlobalContent
            } else {
                SearchContent
            }
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            MainContent
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    SearchInput
                        //.frame(maxWidth: 275)
                    VinePOCEntryPoint
                }
                .padding()
                Divider()
                    .frame(height: 1)
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .onReceive(handle_notify(.new_mutes)) { _ in
            self.model.filter_muted()
        }
        .onAppear {
            if model.events.events.isEmpty {
                loadingTask = Task { await model.load() }
            }
        }
        .onDisappear {
            loadingTask?.cancel()
        }
    }
}

struct SearchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let state = test_damus_state
        SearchHomeView(damus_state: state, model: SearchHomeModel(damus_state: state))
    }
}

struct VinePOCView: View {
    let damus_state: DamusState
    @StateObject private var model: VinePOCModel
    
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
    
    init(damus_state: DamusState) {
        self.damus_state = damus_state
        _model = StateObject(wrappedValue: VinePOCModel(damus_state: damus_state))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                infoCard
                ForEach(model.vines) { vine in
                    VinePOCRow(
                        vine: vine,
                        damus_state: damus_state,
                        relativeDate: relativeDate(for: vine)
                    )
                }
                
                if model.vines.isEmpty && !model.isLoading {
                    Text("No vines found yet. Try again in a moment.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Vine POC")
        .background(Color(uiColor: .systemBackground))
        .overlay {
            if model.isLoading && model.vines.isEmpty {
                ProgressView("Loading vines…")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemBackground))
                    )
                    .shadow(radius: 6)
            }
        }
        .onAppear { model.subscribe() }
        .onDisappear { model.stop() }
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Prototype viewer")
                .font(.headline)
            Text("This experimental view streams kind 34236 events directly from relay.divine.video. Expect rough edges while we explore the experience.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
    
    private func relativeDate(for entry: VinePOCEntry) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(entry.createdAt))
        return VinePOCView.relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}

final class VinePOCModel: ObservableObject {
    @Published private(set) var vines: [VinePOCEntry] = []
    @Published var isLoading: Bool = false
    
    private var subscriptionTask: Task<Void, Never>?
    private let damus_state: DamusState
    private let divineRelay = RelayURL("wss://relay.divine.video")!
    
    init(damus_state: DamusState) {
        self.damus_state = damus_state
    }
    
    func subscribe() {
        stop()
        subscriptionTask = Task { [weak self] in
            guard let self else { return }
            await self.stream()
        }
    }
    
    func stop() {
        subscriptionTask?.cancel()
        subscriptionTask = nil
    }
    
    private func stream() async {
        await damus_state.nostrNetwork.ensureRelayConnected(divineRelay)
        await MainActor.run {
            self.isLoading = true
            self.vines.removeAll()
        }
        
        var filter = NostrFilter(kinds: [.vine_short])
        filter.limit = 50
        let now = UInt32(Date().timeIntervalSince1970)
        filter.until = now
        filter.since = now > 604800 ? now - 604800 : 0
        
        for await item in damus_state.nostrNetwork.reader.advancedStream(filters: [filter], to: [divineRelay]) {
            if Task.isCancelled {
                break
            }
            switch item {
            case .event(let lender):
                await lender.justUseACopy({ await self.handle(event: $0) })
            case .ndbEose:
                await MainActor.run { self.isLoading = false }
            case .eose, .networkEose:
                continue
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    private func handle(event: NostrEvent) async {
        let canDisplay = await MainActor.run {
            should_show_event(state: self.damus_state, ev: event)
        }
        guard canDisplay, let entry = VinePOCEntry(event: event) else {
            return
        }
        
        await MainActor.run {
            if let idx = self.vines.firstIndex(where: { $0.id == entry.id }) {
                self.vines[idx] = entry
            } else {
                self.vines.append(entry)
                self.vines.sort { $0.createdAt > $1.createdAt }
            }
        }
    }
}

struct VinePOCEntry: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let authorDisplay: String
    let createdAt: UInt32
    let videoURL: URL?
    let thumbnailURL: URL?
    let blurhash: String?
    let event: NostrEvent
    
    init?(event: NostrEvent) {
        guard event.known_kind == .vine_short else { return nil }
        let media = VinePOCEntry.extractMedia(from: event)
        guard media.videoURL != nil else { return nil }
        
        self.id = event.id.hex()
        let trimmedContent = event.content.trimmingCharacters(in: .whitespacesAndNewlines)
        self.subtitle = trimmedContent.isEmpty ? nil : trimmedContent
        self.title = VinePOCEntry.extractTagValue(named: "title", in: event) ?? self.subtitle ?? "Untitled Vine"
        let npub = event.pubkey.npub
        if npub.count > 12 {
            let prefix = npub.prefix(8)
            let suffix = npub.suffix(4)
            self.authorDisplay = "\(prefix)…\(suffix)"
        } else {
            self.authorDisplay = npub
        }
        self.createdAt = event.created_at
        self.videoURL = media.videoURL
        self.thumbnailURL = media.thumbnailURL
        self.blurhash = media.blurhash
        self.event = event
    }
    
    private static func extractMedia(from event: NostrEvent) -> (videoURL: URL?, thumbnailURL: URL?, blurhash: String?) {
        var videoURL: URL? = nil
        var thumbnailURL: URL? = nil
        var blurhash: String? = nil
        
        for tag in event.tags {
            let values = tag.strings()
            guard let key = values.first else { continue }
            
            if key == "url", values.count > 1, let candidate = URL(string: values[1]) {
                if videoURL == nil {
                    videoURL = candidate
                }
                continue
            }
            
            if key == "imeta" {
                for entry in values.dropFirst() {
                    let components = entry.split(separator: " ", maxSplits: 1)
                    guard components.count == 2 else { continue }
                    let metaKey = String(components[0])
                    let metaValue = String(components[1])
                    switch metaKey {
                    case "url":
                        if videoURL == nil, let candidate = URL(string: metaValue) {
                            videoURL = candidate
                        }
                    case "image", "thumb":
                        if thumbnailURL == nil, let candidate = URL(string: metaValue) {
                            thumbnailURL = candidate
                        }
                    case "blurhash":
                        if blurhash == nil {
                            blurhash = metaValue
                        }
                    default:
                        continue
                    }
                }
            }
        }
        
        return (videoURL, thumbnailURL, blurhash)
    }
    
    private static func extractTagValue(named key: String, in event: NostrEvent) -> String? {
        for tag in event.tags {
            let values = tag.strings()
            guard let first = values.first, first == key else { continue }
            return values.count > 1 ? values[1] : nil
        }
        return nil
    }
}

fileprivate struct VinePOCRow: View {
    let vine: VinePOCEntry
    let damus_state: DamusState
    let relativeDate: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(vine.title)
                .font(.headline)
            
            Text("by \(vine.authorDisplay) • \(relativeDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let videoURL = vine.videoURL {
                DamusVideoPlayerView(url: videoURL, coordinator: damus_state.video, style: .preview(on_tap: nil))
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else if let thumbnail = vine.thumbnailURL {
                AsyncImage(url: thumbnail) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 220)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, minHeight: 220)
                            .clipped()
                    case .failure:
                        Color.gray.opacity(0.2)
                            .overlay(
                                Image(systemName: "video.slash")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                            )
                            .frame(maxWidth: .infinity, minHeight: 220)
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            
            if let subtitle = vine.subtitle {
                Text(subtitle)
                    .font(.body)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}
