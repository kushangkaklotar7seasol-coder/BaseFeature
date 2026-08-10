//
//  NotesManager.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 29/07/26.
//

import Foundation
import SwiftUI

class NotesManager {
    static let shared = NotesManager()
    
    private let storageKey = "NOTES_SAVE"
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - GET all
    func fetchAllNotes() -> [Notes] {
        guard let data = defaults.data(forKey: storageKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Notes].self, from: data)
        } catch {
            print("Failed to decode notes: \(error)")
            return []
        }
    }
    
    // MARK: - SAVE (overwrite entire list)
    private func save(_ notes: [Notes]) {
        do {
            let encoded = try JSONEncoder().encode(notes)
            defaults.set(encoded, forKey: storageKey)
        } catch {
            print("Failed to encode notes: \(error)")
        }
    }
    
    // MARK: - ADD
    func addNote(_ note: Notes) {
        var notes = fetchAllNotes()
        notes.append(note)
        save(notes)
    }
    
    // MARK: - EDIT
    func updateNote(_ updatedNote: Notes) {
        var notes = fetchAllNotes()
        guard let index = notes.firstIndex(where: { $0.id == updatedNote.id }) else {
            print("Note with id \(updatedNote.id) not found")
            return
        }
        notes[index] = updatedNote
        save(notes)
    }
    
    // MARK: - DELETE
    func deleteNote(id: UUID) {
        var notes = fetchAllNotes()
        notes.removeAll { $0.id == id }
        save(notes)
    }
    
    func deleteAllNotes() {
        save([])
    }
    
    // MARK: - GET single
    func getNote(id: UUID) -> Notes? {
        fetchAllNotes().first { $0.id == id }
    }
}
