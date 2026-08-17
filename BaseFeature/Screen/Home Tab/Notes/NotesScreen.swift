//
//  NotesScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct NotesScreen: View {
    @StateObject var viewModel = NotesViewModel()
    let columns = [
       GridItem(.flexible()),
       GridItem(.flexible())
   ]
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Notes")
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.allNotes.indices, id: \.self) { index in
                            let notes = viewModel.allNotes[index]
                            
                            NotesDesign.NoteCard(notes: notes, onDelete: {
                                viewModel.deleteNote(notes.id)
                            })
                            .onTapGesture {
                                Router.shared.push(.notesDisplay(index: index, allNote: viewModel.allNotes))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        Router.shared.push(.addNote(note: nil))
                    } label: {
                        Image("ic_plus")
                            .resizable()
                            .frame(width: 25, height: 25, alignment: .center)
                            .padding(12)
                            .background(.leftTorightGradient)
                            .cornerRadius(25)
                    }
                }
            }
            .padding(26)
            .padding(.bottom, 30)
            
            if viewModel.allNotes.isEmpty {
                VStack {
                    Image("ic_no_notes")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text("No Notes Yet")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Create your first note to get started.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.grayColour)
                }
            }
        }
        .defaultPage()
        .onAppear() {
            viewModel.loadNotes()
        }
    }
}

#Preview {
    NotesScreen()
}

class NotesDesign {
    struct NoteCard: View {
        var notes: Notes
        var onDelete: (()->Void?)
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    if notes.name != "" {
                        Text(notes.name)
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(2)
                    } else {
                        Text("NO TITLE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.grayColour)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            Router.shared.push(.addNote(note: notes))
                        } label: {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                
                                Text("Edit")
                            }
                        }
                        
                        Button {
                            Utility.shareText(self.shareText(notes))
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                
                                Text("Share")
                            }
                        }
                        
                        Button {
                            self.onDelete()
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                
                                Text("Delete")
                            }
                        }
                        
                    } label: {
                        Image("ic_more")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    
                }
                
                Text(notes.createdDate.formatted(.dateTime.day().month()))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.grayColour)
                    .lineLimit(1)
                
                Text(notes.notes)
                    .font(.system(size: 12, weight: .regular))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .frame(width: (screenWidth-46)/2, height: screenHeight/4, alignment: .top)
            .background(.whiteColour.opacity(0.05))
            .cornerRadius(12)

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
}
