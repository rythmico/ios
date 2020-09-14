import SwiftUI

struct BookingApplicationCell: View {
    var application: BookingApplication

    var body: some View {
        HStack(spacing: .spacingUnit * 2) {
            Dot(color: application.statusInfo.status.color)
            HStack(spacing: .spacingMedium) {
                VStack(alignment: .leading, spacing: .spacingUnit / 2) {
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
        .padding(.vertical, .spacingUnit)
    }

    private var title: String {
        "\(application.student.name) - \(application.instrument.name)"
    }

    private var subtitle: String {
        let startDate = scheduleFormatter.string(from: application.schedule.startDate)
        let status = application.statusInfo.status.title
        return [startDate, status].joined(separator: " • ")
    }

    private var statusDate: String {
        let date = Current.date()
        guard application.statusInfo.date.distance(to: date) >= 60 else {
            return "now"
        }
        return statusDateFormatter.localizedString(
            for: application.statusInfo.date,
            relativeTo: date
        )
    }

    private let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short)
}

#if DEBUG
struct BookingApplicationCell_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(BookingApplication.Status.allCases, id: \.self) { status in
            BookingApplicationCell(application: .stub(.stub(status)))
        }
        .padding(.horizontal, .spacingExtraSmall)
        .previewLayout(.sizeThatFits)
    }
}
#endif
