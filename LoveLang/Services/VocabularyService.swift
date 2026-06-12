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

    init(baseURL: String = "https://api.example.com/v1", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    /// Fetch tất cả từ vựng
    func fetchVocabulary() async throws -> [Vocabulary] {
        // TODO: Thay thế bằng API call thực tế khi có backend
        // let url = URL(string: "\(baseURL)/vocabulary")!
        // let (data, _) = try await session.data(from: url)
        // return try JSONDecoder().decode([Vocabulary].self, from: data)

        // Demo: Trả về dữ liệu mẫu
        return DemoData.vocabularyList
    }

    /// Thêm từ mới qua API
    func addWord(_ request: AddWordRequest) async throws -> AddWordResponse {
        // TODO: Thay thế bằng API call thực tế
        // let url = URL(string: "\(baseURL)/vocabulary")!
        // var urlRequest = URLRequest(url: url)
        // urlRequest.httpMethod = "POST"
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // urlRequest.httpBody = try JSONEncoder().encode(request)
        // let (data, _) = try await session.data(for: urlRequest)
        // return try JSONDecoder().decode(AddWordResponse.self, from: data)

        // Demo: Giả lập response thành công
        let newWord = Vocabulary(
            word: request.word,
            pronunciation: request.pronunciation,
            meaning: request.meaning,
            partOfSpeech: PartOfSpeech(rawValue: request.partOfSpeech ?? "Unknown") ?? .unknown,
            example: request.example
        )
        return AddWordResponse(success: true, message: "Word added successfully", word: newWord)
    }

    /// Cập nhật từ vựng
    func updateWord(_ word: Vocabulary) async throws {
        // TODO: Thay thế bằng API call thực tế
        // let url = URL(string: "\(baseURL)/vocabulary/\(word.id)")!
        // var urlRequest = URLRequest(url: url)
        // urlRequest.httpMethod = "PUT"
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // urlRequest.httpBody = try JSONEncoder().encode(word)
        // _ = try await session.data(for: urlRequest)
    }

    /// Xóa từ vựng
    func deleteWord(_ id: UUID) async throws {
        // TODO: Thay thế bằng API call thực tế
        // let url = URL(string: "\(baseURL)/vocabulary/\(id)")!
        // var urlRequest = URLRequest(url: url)
        // urlRequest.httpMethod = "DELETE"
        // _ = try await session.data(for: urlRequest)
    }

    /// Đánh dấu từ đã học/chưa học
    func markAsLearned(_ id: UUID, isLearned: Bool) async throws {
        // TODO: Thay thế bằng API call thực tế
    }
}
