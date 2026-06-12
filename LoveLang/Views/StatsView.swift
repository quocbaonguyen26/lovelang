import SwiftUI

/// View hiển thị thống kê học tập
struct StatsView: View {
    let stats: LearningStats
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress circle
                    progressCircle

                    // Stats cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            icon: "book.fill",
                            title: "Total Words",
                            value: "\(stats.totalWords)",
                            color: Color(hex: "#6C5CE7")
                        )

                        StatCard(
                            icon: "checkmark.circle.fill",
                            title: "Known",
                            value: "\(stats.learnedWords)",
                            color: .green
                        )

                        StatCard(
                            icon: "arrow.clockwise",
                            title: "Reviewing",
                            value: "\(stats.reviewingWords)",
                            color: .orange
                        )

                        StatCard(
                            icon: "calendar",
                            title: "Today",
                            value: "\(stats.todayReviewed)",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)

                    // Progress bar
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Overall Progress")
                                .font(.headline)
                            Spacer()
                            Text("\(Int(stats.progressPercentage))%")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#6C5CE7"))
                        }

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#6C5CE7").opacity(0.2))
                                    .frame(height: 16)

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * stats.progressPercentage / 100, height: 16)
                            }
                        }
                        .frame(height: 16)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Encouragement message
                    encouragementView
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var progressCircle: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: "#6C5CE7").opacity(0.2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: stats.progressPercentage / 100)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: stats.progressPercentage)

            VStack(spacing: 4) {
                Text("\(Int(stats.progressPercentage))%")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#6C5CE7"))

                Text("Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 150, height: 150)
        .padding(.top)
    }

    @ViewBuilder
    private var encouragementView: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(Color(hex: "#6C5CE7"))

            Text(messageText)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#6C5CE7").opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var messageText: String {
        switch stats.progressPercentage {
        case 0..<25:
            return "Great start! Keep learning!"
        case 25..<50:
            return "You're making progress!"
        case 50..<75:
            return "Halfway there! Amazing!"
        case 75..<100:
            return "Almost there! Keep going!"
        default:
            return "Perfect! You're a champion!"
        }
    }

    private var iconName: String {
        switch stats.progressPercentage {
        case 0..<25:
            return "sparkles"
        case 25..<50:
            return "flame.fill"
        case 50..<75:
            return "star.fill"
        case 75..<100:
            return "crown.fill"
        default:
            return "trophy.fill"
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    StatsView(stats: LearningStats(
        totalWords: 50,
        learnedWords: 25,
        reviewingWords: 25,
        todayReviewed: 10
    ))
}
