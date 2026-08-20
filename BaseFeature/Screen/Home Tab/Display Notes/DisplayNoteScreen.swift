//
//  DisplayNoteScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct DisplayNoteScreen: View {
    @StateObject var viewModel: DisplayNotesViewModel
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "NOTES")
                
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                if let name = viewModel.notes?.name, name != "" {
//                                    Text(name)
//                                        .font(.system(size: 18, weight: .bold))
                                    
                                    SelectableText(text: name, font: .systemFont(ofSize: 18, weight: .bold))
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                } else {
                                    Text("NO_TITLE".localized())
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.grayColour)
                                }
                                
                                Spacer()
                                
                                Menu {
                                    Button {
                                        Router.shared.push(.addNote(note: viewModel.notes))
                                    } label: {
                                        HStack {
                                            Image(systemName: "pencil.circle.fill")
                                                .resizable()
                                                .frame(width: 15, height: 15, alignment: .center)
                                            
                                            Text("EDIT".localized())
                                        }
                                    }
                                    
                                    Button {
                                        if let notes = viewModel.notes {
                                            Utility.shareText(self.shareText(notes))
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up.circle.fill")
                                                .resizable()
                                                .frame(width: 15, height: 15, alignment: .center)
                                            
                                            Text("SHARE".localized())
                                        }
                                    }
                                    
                                    Button {
                                        viewModel.deleteNote()
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
                            
                            if let createdDate = viewModel.notes?.createdDate {
                                Text(createdDate.formatted(.dateTime.day().month()))
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.grayColour)
                            }
                            
                            if let note = viewModel.notes?.notes {
//                                Text(note)
//                                    .font(.system(size: 12, weight: .regular))
//                                    .padding(.top, 1)
                                
                                SelectableText(text: note, font: .systemFont(ofSize: 12, weight: .regular))
                                    .padding(.top, 1)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(.whiteColour.opacity(0.08))
                .cornerRadius(20)
                
                HStack(spacing: 24) {
                    if viewModel.notesIndex > 0 {
                        Button {
                            if viewModel.notesIndex > 0 {
                                viewModel.notesIndex -= 1
                            }
                            viewModel.setNote()
                        } label: {
                            Image("ic_arrow_left")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteColour)
                                .frame(width: 24, height: 24, alignment: .center)
                                .padding(10)
                                .background(.whiteColour.opacity(0.2))
                                .cornerRadius(22)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22)
                                        .strokeBorder(.whiteColour, lineWidth: 0.5)
                                }
                        }
                    } else {
                        Image("ic_arrow_left")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.grayColour.opacity(0.2))
                            .frame(width: 24, height: 24, alignment: .center)
                            .padding(10)
                            .background(.grayColour.opacity(0.1))
                            .cornerRadius(22)
                            .overlay {
                                RoundedRectangle(cornerRadius: 22)
                                    .strokeBorder(.grayColour.opacity(0.2), lineWidth: 1)
                            }
                    }
                    
                    if viewModel.notesIndex < viewModel.allNotes.count - 1 {
                        Button {
                            if viewModel.notesIndex < viewModel.allNotes.count - 1 {
                                viewModel.notesIndex += 1
                            }
                            viewModel.setNote()
                        } label: {
                            Image("ic_arrow_right")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteColour)
                                .frame(width: 24, height: 24, alignment: .center)
                                .padding(10)
                                .background(.whiteColour.opacity(0.2))
                                .cornerRadius(22)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22)
                                        .strokeBorder(.whiteColour, lineWidth: 0.5)
                                }
                        }
                        
                        
                    } else {
                        Image("ic_arrow_right")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.grayColour.opacity(0.2))
                            .frame(width: 24, height: 24, alignment: .center)
                            .padding(10)
                            .background(.grayColour.opacity(0.1))
                            .cornerRadius(22)
                            .overlay {
                                RoundedRectangle(cornerRadius: 22)
                                    .strokeBorder(.grayColour.opacity(0.2), lineWidth: 1)
                            }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .onAppear() {
            viewModel.loadNotes()
        }
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

#Preview {
    DisplayNoteScreen(viewModel: DisplayNotesViewModel())
}

struct SelectableText: UIViewRepresentable {
    let text: String
    let font: UIFont
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.font = font
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        
        // Layout fix
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font
    }
}
