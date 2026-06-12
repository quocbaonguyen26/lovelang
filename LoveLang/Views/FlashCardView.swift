import SwiftUI

/// View hiển thị một flash card với thông tin từ vựng
struct FlashCardView: View {
    let vocabulary: Vocabulary
    @Binding var isFlipped: Bool
    var swipeResult: SwipeDirection = .none

    var body: some View {
        ZStack {
            // Mặt sau (định nghĩa)
            CardBackView(vocabulary: vocabulary)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )

            // Mặt trước (từ tiếng anh)
            CardFrontView(vocabulary: vocabulary)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .overlay(alignment: .topTrailing) {
            swipeResultOverlay
        }
    }

    @ViewBuilder
    private var swipeResultOverlay: some View {
        if swipeResult != .none {
            SwipeIndicator(isKnown: swipeResult.isKnown)
                .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - Card Front View (Từ tiếng Anh)

struct CardFrontView: View {
    let vocabulary: Vocabulary

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Từ loại
            Text(vocabulary.partOfSpeech.abbreviation)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(hex: "#6C5CE7"))
                .cornerRadius(20)

            // Từ tiếng Anh
            Text(vocabulary.word)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            // Cách phát âm
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(Color(hex: "#6C5CE7"))

                Text(vocabulary.pronunciation)
                    .font(.system(size: 18, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Gợi ý tap để lật
            HStack {
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(Color(hex: "#6C5CE7"))
                Text("Tap to flip")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 30)
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
    }
}

// MARK: - Card Back View (Định nghĩa)

struct CardBackView: View {
    let vocabulary: Vocabulary

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text(vocabulary.partOfSpeech.abbreviation)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "#6C5CE7"))
                        .cornerRadius(20)

                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }

                // Từ tiếng Anh
                Text(vocabulary.word)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                // Cách phát âm
                Text(vocabulary.pronunciation)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)

                Divider()

                // Định nghĩa
                Text("Meaning")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text(vocabulary.meaning)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                // Ví dụ
                if let example = vocabulary.example {
                    Divider()

                    Text("Example")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text(example)
                        .font(.body)
                        .italic()
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Từ đồng nghĩa
                if let synonyms = vocabulary.synonyms, !synonyms.isEmpty {
                    Divider()

                    Text("Synonyms")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    FlowLayout(spacing: 8) {
                        ForEach(synonyms, id: \.self) { synonym in
                            Text(synonym)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#6C5CE7"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(hex: "#6C5CE7").opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }

                Spacer(minLength: 30)

                // Gợi ý tap để lật
                HStack {
                    Image(systemName: "arrow.left.and.right")
                        .foregroundColor(Color(hex: "#6C5CE7"))
                    Text("Tap to flip back")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
    }
}

// MARK: - Swipe Indicator

struct SwipeIndicator: View {
    let isKnown: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isKnown ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title2)

            Text(isKnown ? "Known" : "Learning")
                .font(.headline)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(isKnown ? Color.green : Color.orange)
                .shadow(radius: 5)
        )
        .padding(.top, 20)
        .rotationEffect(.degrees(-15))
    }
}

// MARK: - Flow Layout for Synonyms

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
                self.size.width = max(self.size.width, currentX)
            }

            self.size.height = currentY + lineHeight
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    FlashCardView(
        vocabulary: DemoData.vocabularyList[0],
        isFlipped: .constant(false)
    )
    .frame(height: 500)
    .padding()
}
