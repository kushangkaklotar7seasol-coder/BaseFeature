//
//  DisplayNotesViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import Foundation
import Combine

class DisplayNotesViewModel: ObservableObject {
    @Published var notes: Notes?
    @Published var notesIndex: Int = 0
    @Published var allNotes: [Notes] = []
    
    private let manager = NotesManager.shared
    
    init(notesIndex: Int? = 0, allNotes: [Notes] = []) {
        self.notesIndex = notesIndex ?? 0
        self.allNotes = allNotes
        if !allNotes.isEmpty {
            self.notes = allNotes[notesIndex ?? 0]
        }
    }
    
    func setNote() {
        self.notes = self.allNotes[notesIndex]
    }
    
    func deleteNote() {
        if let id = self.notes?.id {
            self.manager.deleteNote(id: id)
            self.allNotes.removeAll(where: { $0.id == id })
        }
        
        if self.allNotes.isEmpty {
            Router.shared.pop()
            return
        }
        
        if self.notesIndex >= self.allNotes.count {
            self.notesIndex = self.allNotes.count - 1
        }
        
        self.setNote()
    }
    
    func loadNotes() {
        self.allNotes = self.manager.fetchAllNotes()
        
        self.notes = self.allNotes.first(where: {$0.id == self.notes?.id})
    }
}
