import SwiftUI

struct LessonPlanApplicationDetailAboutView: View, VisibleView {
    @StateObject
    var coordinator: APIActivityCoordinator<GetPortfolioRequest>
    @State
    private var selectedVideo: Portfolio.Video?
    @State
    private var selectedPhoto: Portfolio.Photo?
    @State
    var isVisible = false

    var tutor: LessonPlan.Tutor

    var body: some View {
        ScrollView {
            content.padding(.vertical, .spacingMedium)
        }
        .visible(self)
        .onAppearOrForeground(self, perform: fetchPortfolio)
        .onDisappear(perform: coordinator.cancel)
        .alertOnFailure(coordinator)
    }

    @ViewBuilder
    private var content: some View {
        switch coordinator.state {
        case .ready, .suspended, .finished(.failure), .idle:
            Color(.systemBackground)
        case .loading:
            ZStack {
                Color(.systemBackground)
                ActivityIndicator(color: .rythmicoGray90)
            }
        case .finished(.success(let portfolio)):
            portfolioView(portfolio)
        }
    }

    @ViewBuilder
    private func portfolioView(_ portfolio: Portfolio) -> some View {
        VStack(spacing: .spacingMedium) {
            VStack(spacing: .spacingSmall) {
                HStack(spacing: .spacingSmall) {
                    header("Bio")
                    MultiStyleText(parts: age(from: portfolio))
                }

                bio(from: portfolio)
                    .rythmicoFont(.body)
                    .lineSpacing(.spacingUnit * 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)

            Divider().overlay(Color.rythmicoGray20)

            if !portfolio.training.isEmpty {
                VStack(spacing: .spacingSmall) {
                    header("Training")
                    PortfolioTrainingsView(trainingList: portfolio.training)
                }
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingMedium)
            }

            if !portfolio.videos.isEmpty || !portfolio.photos.isEmpty {
                Divider().overlay(Color.rythmicoGray20)
            }

            if !portfolio.videos.isEmpty {
                VStack(spacing: .spacingSmall) {
                    header("Videos")
                        .frame(maxWidth: .spacingMax)
                        .padding(.horizontal, .spacingMedium)
                    VideoCarouselView(videos: portfolio.videos, selectedVideo: $selectedVideo)
                }
            }

            if !portfolio.photos.isEmpty {
                VStack(spacing: .spacingSmall) {
                    header("Photos")
                    PhotoCarouselView(photos: portfolio.photos, selectedPhoto: $selectedPhoto)
                }
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingMedium)
            }
        }
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoFont(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func bio(from portfolio: Portfolio) -> some View {
        if portfolio.bio.isBlank {
            Text("\(tutor.name.firstWord ?? "Tutor") did not add a bio.").foregroundColor(.rythmicoGray30)
        } else {
            ExpandableText(portfolio.bio).foregroundColor(.rythmicoGray90)
        }
    }

    private func age(from portfolio: Portfolio) -> [MultiStyleText.Part] {
        "Age: ".color(.rythmicoGray90) + "\(portfolio.age)".color(.rythmicoGray90).style(.bodyBold)
    }

    private func fetchPortfolio() {
        coordinator.start(with: .init(tutorId: tutor.id))
    }
}

#if DEBUG
struct LessonPlanApplicationDetailAboutView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LessonPlanApplicationDetailAboutView(
                coordinator: Current.coordinator(for: \.portfolioFetchingService)!,
                tutor: .charlotteStub
            )
        }
    }
}
#endif
