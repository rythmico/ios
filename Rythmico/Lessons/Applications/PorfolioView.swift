import SwiftUISugar

struct PortfolioView: View {
    private static let bioId = "bio"

    var tutor: Tutor
    var portfolio: Portfolio
    var topPadding: CGFloat

    var body: some View {
        ScrollView { proxy in
            VStack(spacing: .grid(5)) {
                VStack(spacing: .grid(4)) {
                    HStack(spacing: .grid(4)) {
                        header("Bio")
                        ageText(from: portfolio)
                    }

                    bio(from: portfolio, scrollingProxy: proxy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .grid(.max))
                .padding(.horizontal, .grid(5))
                .id(Self.bioId)

                if !portfolio.training.isEmpty {
                    HDivider()
                    VStack(spacing: .grid(4)) {
                        header("Training")
                        PortfolioTrainingsView(trainingList: portfolio.training)
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding(.horizontal, .grid(5))
                }

                if !portfolio.videos.isEmpty || !portfolio.photos.isEmpty {
                    HDivider()
                }

                if !portfolio.videos.isEmpty {
                    VStack(spacing: .grid(4)) {
                        header("Videos")
                            .frame(maxWidth: .grid(.max))
                            .padding(.horizontal, .grid(5))
                        VideoCarouselView(videos: portfolio.videos)
                    }
                }

                if !portfolio.photos.isEmpty {
                    VStack(spacing: .grid(4)) {
                        header("Photos")
                        PhotoCarouselView(photos: portfolio.photos)
                    }
                    .frame(maxWidth: .grid(.max))
                    .padding(.horizontal, .grid(5))
                }
            }
            .padding(.top, topPadding)
            .padding(.bottom, .grid(5))
        }
    }

    @ViewBuilder
    private func header(_ title: String) -> some View {
        Text(title)
            .rythmicoTextStyle(.subheadlineBold)
            .foregroundColor(.rythmico.foreground)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func bio(from portfolio: Portfolio, scrollingProxy: ScrollViewProxy) -> some View {
        if portfolio.bio.isBlank {
            Text("\(tutor.name.firstWord ?? "Tutor") did not add a bio.")
                .rythmicoTextStyle(.body)
                .foregroundColor(.rythmico.textPlaceholder)
        } else {
            ExpandableText(
                content: portfolio.bio,
                onCollapse: { scrollingProxy.scrollTo(Self.bioId, anchor: .bottom) }
            )
            .foregroundColor(.rythmico.foreground)
        }
    }

    private func ageText(from portfolio: Portfolio) -> some View {
        Text(separator: .whitespace) {
            "Age:"
            "\(portfolio.age)".text.rythmicoFontWeight(.bodyBold)
        }
        .rythmicoTextStyle(.body)
        .foregroundColor(.rythmico.foreground)
        .multilineTextAlignment(.trailing)
    }
}
