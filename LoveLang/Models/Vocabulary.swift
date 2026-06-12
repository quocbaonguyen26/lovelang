import Foundation

/// Model đại diện cho một từ vựng
struct Vocabulary: Identifiable, Codable, Equatable {
    let id: UUID
    let word: String
    let pronunciation: String
    let meaning: String
    let partOfSpeech: PartOfSpeech
    let example: String?
    let synonyms: [String]?
    var isLearned: Bool
    var lastReviewedAt: Date?
    var reviewCount: Int

    init(
        id: UUID = UUID(),
        word: String,
        pronunciation: String,
        meaning: String,
        partOfSpeech: PartOfSpeech = .unknown,
        example: String? = nil,
        synonyms: [String]? = nil,
        isLearned: Bool = false,
        lastReviewedAt: Date? = nil,
        reviewCount: Int = 0
    ) {
        self.id = id
        self.word = word
        self.pronunciation = pronunciation
        self.meaning = meaning
        self.partOfSpeech = partOfSpeech
        self.example = example
        self.synonyms = synonyms
        self.isLearned = isLearned
        self.lastReviewedAt = lastReviewedAt
        self.reviewCount = reviewCount
    }
}

/// Các loại từ loại trong tiếng Anh
enum PartOfSpeech: String, Codable, CaseIterable {
    case noun = "Noun"           // Danh từ
    case verb = "Verb"           // Động từ
    case adjective = "Adjective" // Tính từ
    case adverb = "Adverb"       // Trạng từ
    case pronoun = "Pronoun"     // Đại từ
    case preposition = "Preposition" // Giới từ
    case conjunction = "Conjunction" // Liên từ
    case interjection = "Interjection" // Thán từ
    case unknown = "Unknown"

    var abbreviation: String {
        switch self {
        case .noun: return "n."
        case .verb: return "v."
        case .adjective: return "adj."
        case .adverb: return "adv."
        case .pronoun: return "pron."
        case .preposition: return "prep."
        case .conjunction: return "conj."
        case .interjection: return "interj."
        case .unknown: return ""
        }
    }

    var color: String {
        switch self {
        case .noun: return "nounColor"
        case .verb: return "verbColor"
        case .adjective: return "adjectiveColor"
        case .adverb: return "adverbColor"
        case .pronoun: return "pronounColor"
        case .preposition: return "prepositionColor"
        case .conjunction: return "conjunctionColor"
        case .interjection: return "interjectionColor"
        case .unknown: return "unknownColor"
        }
    }
}
