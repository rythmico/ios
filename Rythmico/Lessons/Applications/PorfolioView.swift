import SwiftUI

struct PortfolioView: View {
    private static let bioId = "bio"

    var tutor: Tutor
    var portfolio: Portfolio

    var body: some View {
        ScrollView { proxy in
            VStack(spacing: .spacingMedium) {
                VStack(spacing: .spacingSmall) {
                    HStack(spacing: .spacingSmall) {
                        header("Bio")
                        ageText(from: portfolio)
                    }

                    bio(from: portfolio, scrollingProxy: proxy)
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
                        VideoCarouselView(videos: portfolio.videos)
                    }
                }

                if !portfolio.photos.isEmpty {
                    VStack(spacing: .spacingSmall) {
                        header("Photos")
                        PhotoCarouselView(photos: portfolio.photos)
                    }
                    .frame(maxWidth: .spacingMax)
                    .padding(.horizontal, .spacingMedium)
                }
            }
            .padding(.vertical, .spacingMedium)
        }
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoTextStyle(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func bio(from portfolio: Portfolio, scrollingProxy: ScrollViewProxy) -> some View {
        if portfolio.bio.isBlank {
            Text("\(tutor.name.firstWord ?? "Tutor") did not add a bio.")
                .rythmicoTextStyle(.body)
                .foregroundColor(.rythmicoGray30)
        } else {
            ExpandableText(
                content: portfolio.bio,
                onCollapse: { scrollingProxy.scrollTo(Self.bioId, anchor: .bottom) }
            )
            .foregroundColor(.rythmicoGray90)
        }
    }

    private func ageText(from portfolio: Portfolio) -> some View {
        Text(separator: .whitespace) {
            "Age:"
            "\(portfolio.age)".text.rythmicoFontWeight(.bodyBold)
        }
        .rythmicoTextStyle(.body)
        .foregroundColor(.rythmicoGray90)
        .multilineTextAlignment(.trailing)
    }
}
