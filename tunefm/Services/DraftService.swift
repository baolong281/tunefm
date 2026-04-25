//
//  DraftService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import CoreData

struct DraftService {
    private static var context: NSManagedObjectContext {
        PersistenceController.shared.context
    }

    static func fetchDrafts() -> [Draft] {
        let request = DraftEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            let results = try context.fetch(request)
            return results.map { Draft(from: $0) }
        } catch {
            print("Failed to fetch drafts: \(error.localizedDescription)")
            return []
        }
    }

    static func saveDraft(album: Album, rating: Double, reviewText: String) {
        let draft = DraftEntity(context: context)
        draft.id = UUID()
        draft.albumName = album.collectionName
        draft.artist = album.artistName
        draft.artworkURL = album.artworkUrl100
        draft.albumReleaseDate = album.releaseDate
        draft.rating = rating
        draft.reviewText = reviewText
        draft.timestamp = Date()
        save()
    }

    static func updateDraft(_ draft: Draft, rating: Double, reviewText: String) {
        let request = DraftEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", draft.id as CVarArg)
        do {
            if let managed = try context.fetch(request).first {
                managed.rating = rating
                managed.reviewText = reviewText
                save()
            }
        } catch {
            print("Failed to update draft: \(error.localizedDescription)")
        }
    }

    static func deleteDraft(_ draft: Draft) {
        let request = DraftEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", draft.id as CVarArg)
        do {
            if let managed = try context.fetch(request).first {
                context.delete(managed)
                save()
            }
        } catch {
            print("Failed to delete draft: \(error.localizedDescription)")
        }
    }

    private static func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
