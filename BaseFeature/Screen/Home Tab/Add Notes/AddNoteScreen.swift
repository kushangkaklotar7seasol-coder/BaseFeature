//
//  AddNoteScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct AddNoteScreen: View {
    @StateObject var viewModel: AddNoteViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title
        case notes
    }
    
    var body: some View {
        ZStack {
            // MARK: - 1. Fixed Background (ઝીરો મુવમેન્ટ)
            GeometryReader { geometry in
                Image("img_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
                Utility.closeKeyboard()
            }
            
            // MARK: - 2. Foreground Content
            VStack(spacing: 0) {
                // Header (Top Bar)
                HStack {
                    Button {
                        Router.shared.pop()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.isEdit ? "EDIT_NOTES".localized() : "NEW_NOTES".localized())
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    if !viewModel.nameTextField.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        !viewModel.notesTextEditor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        
                        Button {
                            focusedField = nil
                            Utility.closeKeyboard()
                            viewModel.onSaveButton()
                        } label: {
                            Image("ic_right")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                        .frame(width: 32, height: 32, alignment: .center)
                        
                    } else {
                        Color.clear
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                }
                .padding(.bottom, 10)
                
                // Title Input
                TextField(
                    "",
                    text: $viewModel.nameTextField,
                    prompt: Text("ENTER_NOTE_TITLE".localized())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.whiteColour.opacity(0.2))
                )
                .font(.system(size: 14, weight: .regular))
                .focused($focusedField, equals: .title)
                .padding()
                .background(.whiteColour.opacity(0.08))
                .cornerRadius(10)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            TextField(
                                "",
                                text: $viewModel.notesTextEditor,
                                prompt: Text("START_TYPING".localized())
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(.grayColour.opacity(0.4)),
                                axis: .vertical
                            )
                            .font(.system(size: 16, weight: .regular))
                            .focused($focusedField, equals: .notes)
                            
                            Color.clear
                                .frame(height: 20)
                                .id("BOTTOM_MARKER")
                        }
                        .padding()
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .contentShape(Rectangle())
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.top)
                    .onTapGesture {
                        focusedField = .notes
                        if viewModel.notesTextEditor.isEmpty {
                            viewModel.notesTextEditor = "• "
                        }
                    }
                    .onChange(of: viewModel.notesTextEditor) { oldValue, newValue in
                        self.handleBulletPoints(oldValue: oldValue, newValue: newValue)
                        
                        withAnimation(.easeOut(duration: 0.1)) {
                            proxy.scrollTo("BOTTOM_MARKER", anchor: .bottom)
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                // Bottom Action Button
                if (!viewModel.nameTextField.isEmpty || !viewModel.notesTextEditor.isEmpty) && focusedField == nil {
                    DefaultDesign.FullScreenButton(
                        name: viewModel.isEdit ? "UPDATE" : "DONE",
                        onClick: {
                            viewModel.onSaveButton()
                        }
                    )
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden(true)
        .foregroundColor(.whiteColour)
    }
    
    private func handleBulletPoints(oldValue: String, newValue: String) {
        if newValue.count < oldValue.count {
            return
        }
        
        if oldValue.isEmpty && !newValue.isEmpty && !newValue.hasPrefix("• ") {
            viewModel.notesTextEditor = "• " + newValue
            return
        }
        
        if newValue.hasSuffix("\n") {
            viewModel.notesTextEditor += "• "
            return
        }
    }
}

#Preview {
    AddNoteScreen(viewModel: AddNoteViewModel())
}
