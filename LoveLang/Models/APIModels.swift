import Foundation

/// Model cho API response khi thêm từ mới
struct AddWordResponse: Codable {
    let success: Bool
    let message: String
    let word: Vocabulary?
}

/// Request body khi thêm từ mới
struct AddWordRequest: Codable {
    let word: String
    let pronunciation: String
    let meaning: String
    let partOfSpeech: String?
    let example: String?
}

/// Thống kê học tập
struct LearningStats: Codable {
    var totalWords: Int
    var learnedWords: Int
    var reviewingWords: Int
    var todayReviewed: Int

    var progressPercentage: Double {
        guard totalWords > 0 else { return 0 }
        return Double(learnedWords) / Double(totalWords) * 100
    }

    static var empty: LearningStats {
        LearningStats(totalWords: 0, learnedWords: 0, reviewingWords: 0, todayReviewed: 0)
    }
}
