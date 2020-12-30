import SwiftUI

struct BookingRequestCell: View {
    var request: BookingRequest
    @ObservedObject
    private var state = Current.state

    var body: some View {
        NavigationLink(
            destination: BookingRequestDetailView(bookingRequest: request),
            tag: request,
            selection: $state.requestsContext.selectedRequest
        ) {
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

                Text(accessory)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            .padding(.vertical, .spacingUnit)
        }
    }

    private var title: String {
        "\(request.student.name) - \(request.instrument.name)"
    }

    private var subtitle: String {
        scheduleFormatter.string(from: request.schedule.startDate)
    }

    private var accessory: String {
        request.postcode
    }

    private let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
}

#if DEBUG
struct BookingRequestCell_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestCell(request: .stub)
            .padding(.horizontal, .spacingExtraSmall)
            .previewLayout(.sizeThatFits)
    }
}
#endif
