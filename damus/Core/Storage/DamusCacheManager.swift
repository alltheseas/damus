//
//  DamusCacheManager.swift
//  damus
//
//  Created by Daniel D’Aquino on 2023-10-04.
//

import Foundation
import Kingfisher

struct DamusCacheManager {
    static var shared: DamusCacheManager = DamusCacheManager()
    static let max_cache_size_gb_key = "max_cache_size_gb"

    /// Enforces the user's maximum cache size budget.
    /// Splits the budget 2/3 to images, 1/3 to video.
    /// Safe to call from any thread.
    func enforce_cache_limits() {
        let gb = UserDefaults.standard.integer(forKey: DamusCacheManager.max_cache_size_gb_key)
        guard gb > 0 else { return }

        let budget = UInt64(gb) * 1_000_000_000

        // Video cache gets 1/3 of budget — trim oldest files to fit
        enforce_video_size_limit(max_bytes: budget / 3)

        // Image cache gets 2/3 of budget
        let image_limit = UInt(budget * 2 / 3)
        KingfisherManager.shared.cache.diskStorage.config.sizeLimit = image_limit
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }

    /// Deletes oldest video cache files until total size is within the given budget.
    private func enforce_video_size_limit(max_bytes: UInt64) {
        guard let cache_dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("video_cache") else { return }
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: cache_dir, includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey], options: .skipsHiddenFiles) else { return }

        var entries: [(url: URL, date: Date, size: UInt64)] = []
        var total: UInt64 = 0
        for file in files {
            guard let values = try? file.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey]),
                  let date = values.contentModificationDate,
                  let size = values.fileSize else { continue }
            let file_size = UInt64(size)
            entries.append((url: file, date: date, size: file_size))
            total += file_size
        }

        guard total > max_bytes else { return }
        entries.sort { $0.date < $1.date }
        for entry in entries {
            guard total > max_bytes else { break }
            try? fm.removeItem(at: entry.url)
            total -= entry.size
        }
    }

    func clear_cache(damus_state: DamusState, completion: (() -> Void)? = nil) {
        Log.info("Clearing all caches", for: .storage)
        clear_kingfisher_cache(completion: {
            clear_cache_folder(completion: {
                Log.info("All caches cleared", for: .storage)
                completion?()
            })
        })
    }
    
    func clear_kingfisher_cache(completion: (() -> Void)? = nil) {
        Log.info("Clearing Kingfisher cache", for: .storage)
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache {
            Log.info("Kingfisher cache cleared", for: .storage)
            completion?()
        }
    }
    
    func clear_cache_folder(completion: (() -> Void)? = nil) {
        Log.info("Clearing entire cache folder", for: .storage)
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: cacheURL.path)
            
            for fileName in fileNames {
                let filePath = cacheURL.appendingPathComponent(fileName)
                
                // Prevent issues by double-checking if files are in use, and do not delete them if they are.
                // This is not perfect. There is still a small chance for a race condition if a file is opened between this check and the file removal.
                let isBusy = (!(access(filePath.path, F_OK) == -1 && errno == ETXTBSY))
                if isBusy {
                    continue
                }
                
                try FileManager.default.removeItem(at: filePath)
            }
            
            Log.info("Cache folder cleared successfully.", for: .storage)
            completion?()
        } catch {
            Log.error("Could not clear cache folder", for: .storage)
        }
    }
}
