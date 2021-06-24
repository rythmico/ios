import SwiftUI

struct BookingApplicationCell: View {
    var application: BookingApplication

    var body: some View {
        HStack(spacing: .grid(2)) {
            Dot(color: application.statusInfo.status.color)
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
        .padding(.vertical, .grid(1))
    }

    private var title: String {
        "\(application.student.name) - \(application.instrument.standaloneName)"
    }

    private var subtitle: String {
        let startDate = Self.scheduleFormatter.string(from: application.schedule.startDate)
        let status = application.statusInfo.status.title
        return [startDate, status].joined(separator: " • ")
    }

    private var statusDate: String {
        let date = Current.date()
        guard application.statusInfo.date.distance(to: date) >= 60 else {
            return "now"
        }
        return Self.statusDateFormatter.localizedString(
            for: application.statusInfo.date,
            relativeTo: date
        )
    }

    private static let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private static let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short, precise: true)
}

#if DEBUG
struct BookingApplicationCell_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(BookingApplication.Status.allCases, id: \.self) { status in
            BookingApplicationCell(application: .stub(.stub(status)))
        }
        .padding(.horizontal, .grid(3))
        .previewLayout(.sizeThatFits)
    }
}
#endif
