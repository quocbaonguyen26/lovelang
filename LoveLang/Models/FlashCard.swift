import Foundation

/// Model đại diện cho một FlashCard hiển thị
struct FlashCard: Identifiable {
    let id: UUID
    let vocabulary: Vocabulary
    var isFlipped: Bool
    var offset: CGSize
    var rotation: Double

    init(vocabulary: Vocabulary) {
        self.id = vocabulary.id
        self.vocabulary = vocabulary
        self.isFlipped = false
        self.offset = .zero
        self.rotation = 0
    }

    /// Reset trạng thái card về mặc định
    mutating func reset() {
        isFlipped = false
        offset = .zero
        rotation = 0
    }
}

/// Kết quả khi vuốt card
enum SwipeDirection {
    case left    // Không biết từ này
    case right   // Đã biết từ này
    case none    // Chưa vuốt

    var isKnown: Bool {
        self == .right
    }
}
