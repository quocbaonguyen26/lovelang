import Foundation

/// Protocol cho VocabularyService để dễ dàng mock trong test
protocol VocabularyServiceProtocol {
    func fetchVocabulary() async throws -> [Vocabulary]
    func addWord(_ request: AddWordRequest) async throws -> AddWordResponse
    func updateWord(_ word: Vocabulary) async throws
    func deleteWord(_ id: UUID) async throws
    func markAsLearned(_ id: UUID, isLearned: Bool) async throws
}

/// Service để quản lý từ vựng
final class VocabularyService: VocabularyServiceProtocol {
    static let shared = VocabularyService()

    private let baseURL: String
    private let session: URLSession
    private let vocabularyKey = "lovelang_vocabulary"

    init(baseURL: String = "https://api.example.com/v1", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    // MARK: - Persistence

    private func loadPersistedVocabulary() -> [Vocabulary] {
        guard let data = UserDefaults.standard.data(forKey: vocabularyKey) else { return [] }
        return (try? JSONDecoder().decode([Vocabulary].self, from: data)) ?? []
    }

    private func saveVocabulary(_ vocabulary: [Vocabulary]) {
        let data = try? JSONEncoder().encode(vocabulary)
        UserDefaults.standard.set(data, forKey: vocabularyKey)
    }

    // MARK: - Fetch

    func fetchVocabulary() async throws -> [Vocabulary] {
        let persisted = loadPersistedVocabulary()

        if persisted.isEmpty {
            let demoData = DemoData.vocabularyList
            saveVocabulary(demoData)
            return demoData
        }

        return persisted
    }

    // MARK: - Add Word

    func addWord(_ request: AddWordRequest) async throws -> AddWordResponse {
        let newWord = Vocabulary(
            word: request.word,
            pronunciation: request.pronunciation,
            meaning: request.meaning,
            partOfSpeech: PartOfSpeech(rawValue: request.partOfSpeech ?? "Unknown") ?? .unknown,
            example: request.example
        )

        var current = loadPersistedVocabulary()
        current.append(newWord)
        saveVocabulary(current)

        return AddWordResponse(success: true, message: "Word added successfully", word: newWord)
    }

    // MARK: - Update Word

    func updateWord(_ word: Vocabulary) async throws {
        var current = loadPersistedVocabulary()
        if let index = current.firstIndex(where: { $0.id == word.id }) {
            current[index] = word
            saveVocabulary(current)
        }
    }

    // MARK: - Delete Word

    func deleteWord(_ id: UUID) async throws {
        var current = loadPersistedVocabulary()
        current.removeAll { $0.id == id }
        saveVocabulary(current)
    }

    // MARK: - Mark As Learned

    func markAsLearned(_ id: UUID, isLearned: Bool) async throws {
        var current = loadPersistedVocabulary()
        if let index = current.firstIndex(where: { $0.id == id }) {
            current[index].isLearned = isLearned
            current[index].lastReviewedAt = Date()
            current[index].reviewCount += 1
            saveVocabulary(current)
        }
    }
}
