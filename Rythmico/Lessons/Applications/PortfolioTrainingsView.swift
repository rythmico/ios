import SwiftUISugar

struct PortfolioTrainingsView: View {
    @Environment(\.idealHorizontalInsets) private var idealHorizontalInsets

    var trainingList: [Portfolio.Training]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(trainingList, id: \.self) { training in
                VStack(spacing: 0) {
                    RythmicoLabel(
                        asset: Asset.Icon.Label.training,
                        title: Text(training.title).rythmicoFontWeight(.subheadlineBold),
                        titleStyle: .subheadlineBold,
                        titleLineLimit: 2,
                        alignedContentSpacing: alignedContentSpacing(for: training)
                    ) {
                        VStack(alignment: .leading, spacing: .grid(2)) {
                            if let description = training.description.nilIfBlank {
                                Text(description).rythmicoTextStyle(.callout)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            if let duration = training.duration?.description {
                                Text(duration).rythmicoTextStyle(.callout)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.trailing, idealHorizontalInsets.trailing)
                    .padding(.vertical, .grid(3))

                    if shouldShowDivider(for: training) {
                        HDivider()
                    }
                }
            }
        }
        .foregroundColor(.rythmico.foreground)
    }

    func shouldShowDivider(for training: Portfolio.Training) -> Bool {
        guard let index = trainingList.firstIndex(of: training) else { return false }
        return index < trainingList.endIndex - 1
    }

    func alignedContentSpacing(for training: Portfolio.Training) -> CGFloat {
        training.description.nilIfBlank != nil || training.duration?.description != nil
            ? .grid(1)
            : .grid(0)
    }
}

private extension Portfolio.Training.Duration {
    var description: String {
        [fromYear, toYear].map { $0.map(String.init) ?? "now" }.joined(separator: " - ")
    }
}

#if DEBUG
struct PortfolioTrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioTrainingsView(trainingList: .stub)
            PortfolioTrainingsView(trainingList: .stub).background(Color.red).padding(.vertical, .grid(6))
        }
        .previewLayout(.sizeThatFits)
        .padding(.leading, .grid(6))
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
