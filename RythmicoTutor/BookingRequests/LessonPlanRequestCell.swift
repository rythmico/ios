import TutorDO
import SwiftUI

struct LessonPlanRequestCell: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    var request: LessonPlanRequest

    var body: some View {
        Button(action: goToDetail) {
            HStack(spacing: .grid(5)) {
                VStack(alignment: .leading, spacing: .grid(0.5)) {
                    Text(title)
                        .foregroundColor(.primary)
                        .font(.body)
                    Text(subtitle)
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(accessory)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            .cellAccessory(.disclosure)
            .padding(.vertical, .grid(1))
        }
    }

    private var title: String {
        "\(request.student.firstName) - \(request.instrument.standaloneName)"
    }

    private static let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private var subtitle: String {
        Self.scheduleFormatter.string(
            from: Date(
                date: request.schedule.start,
                time: request.schedule.time,
                in: Current.timeZone()
            )
        )
    }

    private var accessory: String {
        request.address.formatted(style: .singleLine)
    }

    private func goToDetail() {
        navigator.go(to: LessonPlanRequestDetailScreen(lessonPlanRequest: request), on: currentScreen)
    }
}

#if DEBUG
struct LessonPlanRequestCell_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestCell(request: .stub)
            .padding(.horizontal, .grid(3))
            .previewLayout(.sizeThatFits)
    }
}
#endif
