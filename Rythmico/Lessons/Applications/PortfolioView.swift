import SwiftUIEncore

struct PortfolioView: View {
    private struct BioId: Hashable {}

    var tutor: Tutor
    var portfolio: Portfolio
    var topPadding: CGFloat

    var body: some View {
        ScrollView { proxy in
            VStack(spacing: .grid(5)) {
                HeadlineContentView("Bio", accessory: ageText(from: portfolio)) { padding in
                    bio(from: portfolio, scrollingProxy: proxy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(padding)
                }
                .frame(maxWidth: .grid(.max))
                .id(BioId())

                if !portfolio.training.isEmpty {
                    HDivider()
                }

                VStack(spacing: 0) {
                    if !portfolio.training.isEmpty {
                        HeadlineContentView("Training") { padding in
                            PortfolioTrainingsView(trainingList: portfolio.training)
                                .padding(.leading, padding.leading)
                        }
                        .frame(maxWidth: .grid(.max))
                    }

                    if !portfolio.videos.isEmpty || !portfolio.photos.isEmpty {
                        HDivider()
                    }
                }

                if !portfolio.videos.isEmpty {
                    HeadlineContentView("Videos", spacing: .grid(4)) { _ in
                        VideoCarouselView(videos: portfolio.videos)
                    }
                    .frame(maxWidth: .grid(.max))
                }

                if !portfolio.photos.isEmpty {
                    HeadlineContentView("Photos", spacing: .grid(4)) { padding in
                        PhotoCarouselView(photos: portfolio.photos).padding(padding)
                    }
                    .frame(maxWidth: .grid(.max))
                }
            }
            .padding(.top, topPadding)
            .padding(.bottom, .grid(5))
        }
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
                onCollapse: { scrollingProxy.scrollTo(BioId(), anchor: .bottom) }
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
