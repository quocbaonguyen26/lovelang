import SwiftUI

/// View chính hiển thị flash card với gesture vuốt
struct SwipeableCardView: View {
    @ObservedObject var viewModel: FlashCardViewModel

    @State private var offset: CGSize = .zero
    @State private var isFlipped: Bool = false
    @GestureState private var isDragging: Bool = false

    private let swipeThreshold: CGFloat = 100

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if viewModel.isSessionComplete {
                    SessionCompleteView(
                        stats: viewModel.stats,
                        onRestart: { viewModel.restartSession() }
                    )
                } else if let card = viewModel.currentCard {
                    cardContent(card: card, geometry: geometry)
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: offset)
    }

    @ViewBuilder
    private func cardContent(card: FlashCard, geometry: GeometryProxy) -> some View {
        let cardWidth = geometry.size.width - 40

        ZStack {
            // Swipe indicators (shown during drag)
            HStack {
                SwipeHintIndicator(direction: .left, isActive: offset.width < -50)
                Spacer()
                SwipeHintIndicator(direction: .right, isActive: offset.width > 50)
            }
            .padding(.horizontal, 30)

            // Main card
            FlashCardView(
                vocabulary: card.vocabulary,
                isFlipped: $isFlipped,
                swipeResult: viewModel.swipeResult
            )
            .frame(width: cardWidth, height: geometry.size.height * 0.75)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .offset(offset)
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        handleSwipeEnd(translation: gesture.translation)
                    }
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isFlipped.toggle()
                }
            }
        }
    }

    private func handleSwipeEnd(translation: CGSize) {
        let direction: SwipeDirection

        if translation.width > swipeThreshold {
            direction = .right // Known
        } else if translation.width < -swipeThreshold {
            direction = .left // Learning
        } else {
            direction = .none
        }

        if direction != .none {
            // Animate card off screen
            withAnimation(.easeOut(duration: 0.3)) {
                offset = CGSize(
                    width: direction == .right ? 500 : -500,
                    height: 0
                )
            }

            viewModel.handleSwipe(direction)

            // Reset for next card
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                offset = .zero
                isFlipped = false
            }
        } else {
            // Snap back
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                offset = .zero
            }
        }
    }
}

// MARK: - Swipe Hint Indicator

struct SwipeHintIndicator: View {
    let direction: SwipeDirection
    let isActive: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: direction == .right ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(direction.isKnown ? .green : .orange)
                .opacity(isActive ? 1 : 0.3)
                .scaleEffect(isActive ? 1.2 : 1)

            Text(direction == .right ? "Know it" : "Learning")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(direction.isKnown ? .green : .orange)
                .opacity(isActive ? 1 : 0.3)
        }
    }
}

// MARK: - Session Complete View

struct SessionCompleteView: View {
    let stats: LearningStats
    let onRestart: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Celebration icon
            Image(systemName: "star.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(Color(hex: "#6C5CE7"))

            Text("Session Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Great job! You've reviewed all cards.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            // Stats
            VStack(spacing: 16) {
                StatRow(icon: "book.fill", title: "Total Words", value: "\(stats.totalWords)", color: Color(hex: "#6C5CE7"))
                StatRow(icon: "checkmark.circle.fill", title: "Known", value: "\(stats.learnedWords)", color: .green)
                StatRow(icon: "arrow.clockwise", title: "Need Review", value: "\(stats.reviewingWords)", color: .orange)
            }
            .padding(24)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal, 40)

            Spacer()

            // Restart button
            Button(action: onRestart) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Start New Session")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#6C5CE7"))
                .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Stat Row

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)

            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    SwipeableCardView(viewModel: FlashCardViewModel())
}
