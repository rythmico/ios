import SwiftUI
import MultiModal

struct PortfolioView: View {
    private static let bioId = "bio"

    @State
    private var selectedVideo: Portfolio.Video?
    @State
    private var selectedPhoto: Portfolio.Photo?

    var tutor: Tutor
    var portfolio: Portfolio

    var body: some View {
        ScrollView { proxy in
            VStack(spacing: .spacingMedium) {
                VStack(spacing: .spacingSmall) {
                    HStack(spacing: .spacingSmall) {
                        header("Bio")
                        ageText(from: portfolio).multilineTextAlignment(.trailing)
                    }

                    bio(from: portfolio, scrollingProxy: proxy)
                        .rythmicoFont(.body)
                        .lineSpacing(.spacingUnit * 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingMedium)
                .id(Self.bioId)

                if !portfolio.training.isEmpty {
                    Divider().overlay(Color.rythmicoGray20)
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
        .multiModal {
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
    private func bio(from portfolio: Portfolio, scrollingProxy: ScrollViewProxy) -> some View {
        if portfolio.bio.isBlank {
            Text("\(tutor.name.firstWord ?? "Tutor") did not add a bio.").foregroundColor(.rythmicoGray30)
        } else {
            ExpandableText(
                content: portfolio.bio,
                onCollapse: { scrollingProxy.scrollTo(Self.bioId, anchor: .bottom) }
            )
            .foregroundColor(.rythmicoGray90)
        }
    }

    private func ageText(from portfolio: Portfolio) -> Text {
        Text {
            "Age: ".text.rythmicoFont(.body)
            "\(portfolio.age)".text.rythmicoFont(.bodyBold)
        }
        .foregroundColor(.rythmicoGray90)
    }
}
