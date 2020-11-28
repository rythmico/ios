import SwiftUI
import MultiSheet

struct PortfolioView: View {
    @State
    private var selectedVideo: Portfolio.Video?
    @State
    private var selectedPhoto: Portfolio.Photo?

    var tutor: Tutor
    var portfolio: Portfolio

    var body: some View {
        ScrollView {
            VStack(spacing: .spacingMedium) {
                VStack(spacing: .spacingSmall) {
                    HStack(spacing: .spacingSmall) {
                        header("Bio")
                        MultiStyleText(parts: age(from: portfolio), alignment: .trailing)
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
            .padding(.vertical, .spacingMedium)
        }
        .multiSheet {
            $0.sheet(item: $selectedVideo, content: VideoCarouselPlayer.init)
            $0.sheet(item: $selectedPhoto) { _ in
                PhotoCarouselDetailView(photos: portfolio.photos, selection: $selectedPhoto)
            }
        }
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoFont(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
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
}
