import SwiftUI

/// View để thêm từ mới
struct AddWordView: View {
    @ObservedObject var viewModel: FlashCardViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var word: String = ""
    @State private var pronunciation: String = ""
    @State private var meaning: String = ""
    @State private var partOfSpeech: PartOfSpeech = .unknown
    @State private var example: String = ""
    @State private var isLoading: Bool = false
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Word (e.g., Serendipity)", text: $word)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Pronunciation (e.g., /ˌser.ənˈdɪp.ə.ti/)", text: $pronunciation)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    Picker("Part of Speech", selection: $partOfSpeech) {
                        ForEach(PartOfSpeech.allCases, id: \.self) { pos in
                            Text(pos.rawValue).tag(pos)
                        }
                    }
                } header: {
                    Text("Word Information")
                }

                Section {
                    TextField("Meaning in Vietnamese", text: $meaning, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Definition")
                }

                Section {
                    TextField("Example sentence (optional)", text: $example, axis: .vertical)
                        .lineLimit(2...4)
                } header: {
                    Text("Example")
                }

                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("You can also add words via API. Contact your backend service for the API endpoint.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Add New Word")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWord()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid || isLoading)
                }
            }
            .overlay {
                if isLoading {
                    LoadingView()
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var isFormValid: Bool {
        !word.isEmpty && !pronunciation.isEmpty && !meaning.isEmpty
    }

    private func saveWord() {
        isLoading = true

        let request = AddWordRequest(
            word: word,
            pronunciation: pronunciation,
            meaning: meaning,
            partOfSpeech: partOfSpeech.rawValue,
            example: example.isEmpty ? nil : example
        )

        Task {
            do {
                try await viewModel.addWord(request)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
            isLoading = false
        }
    }
}

#Preview {
    AddWordView(viewModel: FlashCardViewModel())
}
