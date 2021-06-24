import SwiftUI

struct PortfolioTrainingsView: View {
    var trainingList: [Portfolio.Training]

    var body: some View {
        ForEach(0..<trainingList.count, id: \.self) { index in let training = trainingList[index]
            HStack(alignment: .firstTextBaseline, spacing: .grid(3)) {
                Image(decorative: Asset.Icon.Label.training.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoGray90)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 2 }
                VStack(spacing: .grid(4)) {
                    VStack(spacing: .grid(2)) {
                        VStack(spacing: .grid(1)) {
                            Text(training.title)
                                .foregroundColor(.rythmicoGray90)
                                .rythmicoTextStyle(.bodyBold)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if !training.description.isBlank {
                                Text(training.description)
                                    .foregroundColor(.rythmicoGray90)
                                    .rythmicoTextStyle(.callout)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        if let duration = training.duration?.description {
                            Text(duration)
                                .foregroundColor(.rythmicoGray90)
                                .rythmicoTextStyle(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    if index < trainingList.endIndex - 1 {
                        HDivider()
                    }
                }
            }
        }
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
        VStack(spacing: .grid(5)) {
            PortfolioTrainingsView(trainingList: .stub)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
