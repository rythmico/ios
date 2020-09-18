import SwiftUI

struct PortfolioTrainingsView: View {
    var trainingList: [Portfolio.Training]

    var body: some View {
        ForEach(0..<trainingList.count, id: \.self) { index in let training = trainingList[index]
            HStack(alignment: .firstTextBaseline, spacing: .spacingSmall) {
                Image(decorative: Asset.iconTraining.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmicoGray90)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - 2 }
                VStack(spacing: .spacingSmall) {
                    VStack(spacing: .spacingUnit * 2) {
                        VStack(spacing: .spacingUnit) {
                            Text(training.title)
                                .foregroundColor(.rythmicoGray90)
                                .rythmicoFont(.bodyBold)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if !training.description.isBlank {
                                Text(training.description)
                                    .foregroundColor(.rythmicoGray90)
                                    .rythmicoFont(.callout)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        Text(yearRange(of: training))
                            .foregroundColor(.rythmicoGray90)
                            .rythmicoFont(.callout)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if index < trainingList.endIndex - 1 {
                        Divider().overlay(Color.rythmicoGray20)
                    }
                }
            }
        }
    }

    private func yearRange(of training: Portfolio.Training) -> String {
        [training.fromYear, training.toYear]
            .map { $0.map(String.init) ?? "now" }
            .joined(separator: " - ")
    }
}
