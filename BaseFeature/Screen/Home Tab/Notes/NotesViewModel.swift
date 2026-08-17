//
//  NotesViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import Foundation
import Combine

class NotesViewModel: ObservableObject {
    @Published private(set) var allNotes: [Notes] = []
    
    private let manager = NotesManager.shared
    
    @Published var isShowDeleteAlert: Bool = false
    @Published var deletableNotesId: UUID = UUID()
    
    // MARK: - Load / refresh from storage
    func loadNotes() {
        self.allNotes = self.sortedNotes(pinnedFirst: true, notes: self.manager.fetchAllNotes())
    }
    
    // MARK: - ADD
    func addNote(name: String, notes: String, isPined: Bool = false) {
        let newNote = Notes(
            createdDate: Date(),
            editDate: Date(),
            name: name,
            notes: notes,
            isPined: isPined
        )
        manager.addNote(newNote)
        loadNotes()
    }
    
    // MARK: - EDIT
    func updateNote(id: UUID, name: String? = nil, notes: String? = nil, isPined: Bool? = nil) {
        guard var note = manager.getNote(id: id) else {
            print("Note with id \(id) not found")
            return
        }
        
        if let name = name { note.name = name }
        if let notes = notes { note.notes = notes }
        if let isPined = isPined { note.isPined = isPined }
        note.editDate = Date()
        
        manager.updateNote(note)
        loadNotes()
    }
    
    // MARK: - DELETE
    
    func deleteNote(id: UUID) {
        manager.deleteNote(id: id)
        loadNotes()
    }
    
    func deleteNote(at offsets: IndexSet) {
        offsets.forEach { index in
            let note = allNotes[index]
            manager.deleteNote(id: note.id)
        }
        loadNotes()
    }
    
    func deleteAllNotes() {
        manager.deleteAllNotes()
        loadNotes()
    }
    
    // MARK: - Sorted accessor
    func sortedNotes(pinnedFirst: Bool = true, notes: [Notes]) -> [Notes] {
        pinnedFirst ? notes.sorted { $0.isPined && !$1.isPined } : allNotes
    }
    
    func editNote(_ editNote: Notes){
        manager.updateNote(editNote)
        loadNotes()
    }
    
    func deleteNote(_ id: UUID) {
        manager.deleteNote(id: id)
        loadNotes()
    }
    
    func shareText(_ note: Notes) -> String {
        return """
            Hyy,
            Here is the importent notes for you
            "\(note.name)"
            \(note.notes)
            """
    }
}
