import Foundation
import SwiftUI

/// ViewModel chính quản lý trạng thái flash card
@MainActor
final class FlashCardViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var cards: [FlashCard] = []
    @Published var currentIndex: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingResult: Bool = false
    @Published var swipeResult: SwipeDirection = .none
    @Published var selectedCategory: String = "Today"
    @Published var stats: LearningStats = .empty

    // MARK: - Private Properties

    private let service: VocabularyServiceProtocol
    private var allVocabulary: [Vocabulary] = []

    // MARK: - Computed Properties

    var currentCard: FlashCard? {
        guard currentIndex >= 0, currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var hasNextCard: Bool {
        currentIndex < cards.count - 1
    }

    var hasPreviousCard: Bool {
        currentIndex > 0
    }

    var progress: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(cards.count)
    }

    var remainingCards: Int {
        max(0, cards.count - currentIndex)
    }

    var isSessionComplete: Bool {
        currentIndex >= cards.count
    }

    // MARK: - Initialization

    init(service: VocabularyServiceProtocol = VocabularyService.shared) {
        self.service = service
    }

    // MARK: - Public Methods

    /// Tải dữ liệu từ vựng
    func loadVocabulary() async {
        isLoading = true
        errorMessage = nil

        do {
            allVocabulary = try await service.fetchVocabulary()
            filterAndSetupCards()
            updateStats()
        } catch {
            errorMessage = "Failed to load vocabulary: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// Xử lý vuốt card
    func handleSwipe(_ direction: SwipeDirection) {
        guard let currentCard = currentCard else { return }

        swipeResult = direction
        showingResult = true

        // Cập nhật trạng thái học
        Task {
            try? await service.markAsLearned(currentCard.vocabulary.id, isLearned: direction.isKnown)
        }

        // Cập nhật local để filter đúng ngay lập tức
        if let index = allVocabulary.firstIndex(where: { $0.id == currentCard.vocabulary.id }) {
            allVocabulary[index].isLearned = direction.isKnown
            allVocabulary[index].lastReviewedAt = Date()
            allVocabulary[index].reviewCount += 1
        }

        // Hiệu ứng delay trước khi chuyển card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.moveToNextCard()
            self?.updateStats()
        }
    }

    /// Chuyển sang card tiếp theo
    func moveToNextCard() {
        showingResult = false
        swipeResult = .none

        if hasNextCard {
            currentIndex += 1
        } else {
            currentIndex = cards.count // Đánh dấu hoàn thành
        }
    }

    /// Chuyển về card trước
    func moveToPreviousCard() {
        guard hasPreviousCard else { return }
        currentIndex -= 1
        showingResult = false
        swipeResult = .none
    }

    /// Reset phiên học
    func resetSession() {
        currentIndex = 0
        showingResult = false
        swipeResult = .none
        filterAndSetupCards()
    }

    /// Thêm từ mới
    func addWord(_ request: AddWordRequest) async {
        do {
            let response = try await service.addWord(request)
            if response.success, let newWord = response.word {
                allVocabulary.append(newWord)
                filterAndSetupCards()
                updateStats()
            }
        } catch {
            errorMessage = "Failed to add word: \(error.localizedDescription)"
        }
    }

    /// Đổi category filter
    func selectCategory(_ category: String) {
        selectedCategory = category
        filterAndSetupCards()
    }

    /// Restart phiên học
    func restartSession() {
        resetSession()
    }

    // MARK: - Private Methods

    private func filterAndSetupCards() {
        let filtered: [Vocabulary]

        switch selectedCategory {
        case "Today":
            filtered = getTodayWords()
        case "Reviewing":
            filtered = allVocabulary.filter { !$0.isLearned }
        case "Knew":
            filtered = allVocabulary.filter { $0.isLearned }
        default:
            filtered = allVocabulary
        }

        // Shuffle để random thứ tự
        cards = filtered.shuffled().map { FlashCard(vocabulary: $0) }
        currentIndex = 0
    }

    private func getTodayWords() -> [Vocabulary] {
        let today = Calendar.current.startOfDay(for: Date())
        let reviewing = allVocabulary.filter { !$0.isLearned }

        let newToday = reviewing.filter {
            Calendar.current.isDate($0.addedAt, inSameDayAs: today)
        }

        let olderReviewing = reviewing.filter {
            !Calendar.current.isDate($0.addedAt, inSameDayAs: today)
        }

        // Ưu tiên từ mới hôm nay, sau đó mới đến từ Reviewing cũ
        let combined = newToday + olderReviewing
        return Array(combined.prefix(10))
    }

    private func updateStats() {
        let totalInSession = cards.count
        let reviewedInSession = currentIndex
        let learnedInSession = cards.prefix(currentIndex).filter { $0.vocabulary.isLearned }.count
        let reviewingInSession = reviewedInSession - learnedInSession

        stats = LearningStats(
            totalWords: totalInSession,
            learnedWords: learnedInSession,
            reviewingWords: reviewingInSession,
            todayReviewed: reviewedInSession
        )
    }
}
