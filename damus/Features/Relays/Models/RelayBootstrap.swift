//
//  RelayBootstrap.swift
//  damus
//
//  Created by William Casarin on 2023-04-04.
//

import Foundation

// This is `fileprivate` because external code should use the `get_default_bootstrap_relays` instead.
fileprivate let BOOTSTRAP_RELAYS = [
    "wss://relay.damus.io",
    "wss://nostr.land",
    "wss://nostr.wine",
    "wss://nos.lol",
]

/// Region-specific bootstrap relays keyed by ISO region code (e.g., "JP", "TH", "DE").
fileprivate let REGION_SPECIFIC_BOOTSTRAP_RELAYS: [String: [String]] = [
    "JP": [  // Japan
        "wss://relay-jp.nostr.wirednet.jp",
        "wss://yabu.me",
        "wss://r.kojira.io",
    ],
    "TH": [  // Thailand
        "wss://relay.siamstr.com",
        "wss://relay.zerosatoshi.xyz",
        "wss://th2.nostr.earnkrub.xyz",
    ],
    "DE": [  // Germany
        "wss://nostr.einundzwanzig.space",
        "wss://nostr.cercatrova.me",
        "wss://nostr.bitcoinplebs.de",
    ]
]

func bootstrap_relays_setting_key(pubkey: Pubkey) -> String {
    return pk_setting_key(pubkey, key: "bootstrap_relays")
}

func save_bootstrap_relays(pubkey: Pubkey, relays: [RelayURL])  {
    let key = bootstrap_relays_setting_key(pubkey: pubkey)

    UserDefaults.standard.set(relays.map({ $0.absoluteString }), forKey: key)
}

func load_bootstrap_relays(pubkey: Pubkey) -> [RelayURL] {
    let key = bootstrap_relays_setting_key(pubkey: pubkey)

    guard let relays = UserDefaults.standard.stringArray(forKey: key) else {
        print("loading default bootstrap relays")
        return get_default_bootstrap_relays().map { $0 }
    }
    
    if relays.count == 0 {
        print("loading default bootstrap relays")
        return get_default_bootstrap_relays().map { $0 }
    }

    let relay_urls = relays.compactMap({ RelayURL($0) })

    let loaded_relays = Array(Set(relay_urls))
    print("Loading custom bootstrap relays: \(loaded_relays)")
    return loaded_relays
}

/// Returns the user's region code (e.g., "US", "JP", "DE"), compatible with iOS 15+.
/// Uses Locale.current.region on iOS 16+ and falls back to regionCode on iOS 15.
private func getCurrentRegionCode() -> String? {
    if #available(iOS 16.0, *) {
        return Locale.current.region?.identifier
    } else {
        return Locale.current.regionCode
    }
}

func get_default_bootstrap_relays() -> [RelayURL] {
    var default_bootstrap_relays: [RelayURL] = BOOTSTRAP_RELAYS.compactMap({ RelayURL($0) })

    if let regionCode = getCurrentRegionCode(), let regional_bootstrap_relays = REGION_SPECIFIC_BOOTSTRAP_RELAYS[regionCode] {
        default_bootstrap_relays.append(contentsOf: regional_bootstrap_relays.compactMap({ RelayURL($0) }))
    }

    return default_bootstrap_relays
}
