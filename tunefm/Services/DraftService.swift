//
//  DraftService.swift
//  tunefm
//
//  Created by dylan h on 4/24/26.
//

import CoreData

// draft service is the service responsible for creating, updating, and deleting drafts
// this uses coredata and is saved locally
// also note the context is the main thread context, so we must have that this only ever runs on the main thread
struct DraftService {
    private static var context: NSManagedObjectContext {
        PersistenceController.shared.context
    }

    // fetch the drafts from coredata
    // we need uid since drafts are shared across users locally
    static func fetchDrafts(uid: String) -> [Draft] {
        let request = DraftEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uid == %@", uid)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            let results = try context.fetch(request)
            return results.map { Draft(from: $0) }
        } catch {
            print("Failed to fetch drafts: \(error.localizedDescription)")
            return []
        }
    }

    // save a draft given an album, userid, rating, and text
    // we dont use review object since that has a lot of extra info we want to attach later
    static func saveDraft(album: Album, uid: String, rating: Double, reviewText: String) {
        let draft = DraftEntity(context: context)
        draft.id = UUID()
        draft.uid = uid
        draft.albumName = album.collectionName
        draft.artist = album.artistName
        draft.artworkURL = album.artworkUrl100
        draft.albumReleaseDate = album.releaseDate
        draft.rating = rating
        draft.reviewText = reviewText
        draft.timestamp = Date()
        save()
    }

    // update a draft with new rating and text
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

    // delete a draft matching this one
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

    // commit changes to coredata
    private static func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
