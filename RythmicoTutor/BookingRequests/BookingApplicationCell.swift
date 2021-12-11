import SwiftUIEncore
import TutorDTO

struct LessonPlanApplicationCell: View {
    var application: LessonPlanApplication

    var body: some View {
        HStack(spacing: .grid(2)) {
            Dot(color: application.status.color)
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

                TickingText(statusDate)
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
        }
        .cellAccessory(.disclosure)
        .padding(.vertical, .grid(1))
    }

    private var title: String {
        "\(application.request.student.firstName) - \(application.request.instrument.standaloneName)"
    }

    private var subtitle: String {
        let startDate = Self.scheduleFormatter.string(
            from: Date(
                date: application.request.schedule.start,
                time: application.request.schedule.time,
                in: Current.timeZone()
            )
        )
        let status = application.status.title
        return [startDate, status].joined(separator: " • ")
    }

    private var statusDate: String {
        let date = Current.date()
        guard application.statusDate.distance(to: date) >= 60 else {
            return "now"
        }
        return Self.statusDateFormatter.localizedString(
            for: application.statusDate,
            relativeTo: date
        )
    }

    private static let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private static let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short, precise: true)
}

extension LessonPlanApplication {
    var statusDate: Date {
        switch status {
        case .pending:
            return createdAt
        case .retracted(let retractedAt):
            return retractedAt
        }
    }
}

extension LessonPlanApplication.Status {
    var title: String {
        switch self {
        case .pending: return "Pending"
//        case .cancelled: return "Cancelled"
        case .retracted: return "Retracted"
//        case .notSelected: return "Not Selected"
//        case .selected: return "Selected"
        }
    }

    var summary: String {
        switch self {
        case .pending: return "Pending tutor selection"
//        case .cancelled: return "Cancelled by submitter"
        case .retracted: return "Retracted by you"
//        case .notSelected: return "Not selected"
//        case .selected: return "Selected"
        }
    }

    var color: Color {
        switch self {
        case .pending: return .orange
//        case .cancelled: return .gray
        case .retracted: return .gray
//        case .notSelected: return .red
//        case .selected: return .green
        }
    }
}

#if DEBUG
struct LessonPlanApplicationCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanApplicationCell(application: .stub(.pending))
            LessonPlanApplicationCell(application: .stub(.retracted(try! Current.date() - (10, .second, .neutral))))
        }
        .padding(.horizontal, .grid(3))
        .previewLayout(.sizeThatFits)
    }
}
#endif
