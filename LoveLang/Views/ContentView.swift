import SwiftUI

/// View chính của ứng dụng
struct ContentView: View {
    @StateObject private var viewModel = FlashCardViewModel()
    @State private var showingAddWord = false
    @State private var showingStats = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(hex: "#667eea").opacity(0.1),
                        Color(hex: "#764ba2").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header with stats
                    headerView

                    // Category filter
                    categoryPicker

                    // Progress bar
                    if !viewModel.cards.isEmpty && !viewModel.isSessionComplete {
                        progressView
                    }

                    // Main card area
                    SwipeableCardView(viewModel: viewModel)
                        .padding(.horizontal, 20)

                    // Bottom hint
                    if !viewModel.isSessionComplete && !viewModel.cards.isEmpty {
                        bottomHint
                    }
                }
            }
            .navigationTitle("LoveLang")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(Color(hex: "#6C5CE7"))
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWord = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "#6C5CE7"))
                    }
                }
            }
            .sheet(isPresented: $showingAddWord) {
                AddWordView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingStats) {
                StatsView(stats: viewModel.stats)
            }
            .task {
                await viewModel.loadVocabulary()
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }

    // MARK: - Header View

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Flash Cards")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("\(viewModel.remainingCards) cards remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Progress circle
            ZStack {
                Circle()
                    .stroke(Color(hex: "#6C5CE7").opacity(0.2), lineWidth: 4)

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(Color(hex: "#6C5CE7"), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Text("\(Int(viewModel.progress * 100))%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#6C5CE7"))
            }
            .frame(width: 50, height: 50)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DemoData.categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: viewModel.selectedCategory == category,
                        action: { viewModel.selectCategory(category) }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
    }

    // MARK: - Progress View

    private var progressView: some View {
        VStack(spacing: 8) {
            ProgressView(value: viewModel.progress)
                .tint(Color(hex: "#6C5CE7"))

            HStack {
                Text("Card \(viewModel.currentIndex + 1) of \(viewModel.cards.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if viewModel.hasPreviousCard {
                    Button(action: { viewModel.moveToPreviousCard() }) {
                        Image(systemName: "arrow.left")
                            .font(.caption)
                            .foregroundColor(Color(hex: "#6C5CE7"))
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    // MARK: - Bottom Hint

    private var bottomHint: some View {
        HStack(spacing: 40) {
            VStack(spacing: 4) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                Text("Learning")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 4) {
                Image(systemName: "hand.draw.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "#6C5CE7"))
                Text("Tap to flip")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 4) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Know it")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(hex: "#6C5CE7") : Color(.secondarySystemBackground))
                )
        }
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(Color(.systemGray5))
            .cornerRadius(16)
        }
    }
}

#Preview {
    ContentView()
}
