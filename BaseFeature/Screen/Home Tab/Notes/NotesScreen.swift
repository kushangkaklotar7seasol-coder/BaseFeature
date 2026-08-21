//
//  NotesScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct NotesScreen: View {
    @StateObject var viewModel = NotesViewModel()
//    let columns = [
//       GridItem(.flexible()),
//       GridItem(.flexible())
//   ]
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 4 : Device.isiPadLandscape ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "NOTES")
                
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
                    .id(refreshID)
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
                    
                    Text("NO_NOTES".localized())
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("NO_NOTES_INFO".localized())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.grayColour)
                }
            }
        }
        .defaultPage()
        .onAppear() {
            viewModel.loadNotes()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
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
        
        var cardWidth: CGFloat {
            if Device.isiPadPortrait {
                return (screenWidth-46)/4
            } else if Device.isiPadLandscape {
                return (screenWidth-46)/5
            } else {
                return (screenWidth-46)/2
            }
        }
        
        var cardHeight: CGFloat {
            if Device.isiPadLandscape {
                return screenHeight/3
            } else {
                return screenHeight/4
            }
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    if notes.name != "" {
                        Text(notes.name)
                            .font(.system(size: 14, weight: .bold))
                            .lineLimit(2)
                    } else {
                        Text("NO_TITLE".localized())
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
                                
                                Text("EDIT".localized())
                            }
                        }
                        
                        Button {
                            Utility.shareText(self.shareText(notes))
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                
                                Text("SHARE".localized())
                            }
                        }
                        
                        Button {
                            AlertManager.shared.show(
                                title: "DELETE_NOTE".localized(),
                                message: "DELETE_NOTE_INFO".localized(),
                                buttons: [
                                    AlertButtonModel(title: "CANCEL".localized(), role: .cancel),
                                    AlertButtonModel(title: "DELETE".localized(), role: .destructive) {
                                        self.onDelete()
                                    }
                                ]
                            )
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                                
                                Text("DELETE".localized())
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
            .frame(width: cardWidth, height: cardHeight, alignment: .top)
            .background(.whiteColour.opacity(0.05))
            .cornerRadius(12)

        }
        
        func shareText(_ note: Notes) -> String {
            let notesShare = "NOTES_SHARE".localized()
            return """
                \(notesShare)
                "\(note.name)"
                \(note.notes)
                """
        }
    }
}
