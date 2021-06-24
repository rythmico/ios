import SwiftUI

struct BookingRequestCell: View {
    var request: BookingRequest
    @ObservedObject
    private var navigation = Current.navigation

    var body: some View {
        NavigationLink(
            destination: BookingRequestDetailView(bookingRequest: request),
            tag: request,
            selection: $navigation.requestsNavigation.selectedRequest
        ) {
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
            .padding(.vertical, .grid(1))
        }
    }

    private var title: String {
        "\(request.student.name) - \(request.instrument.standaloneName)"
    }

    private var subtitle: String {
        Self.scheduleFormatter.string(from: request.schedule.startDate)
    }

    private var accessory: String {
        request.postcode
    }

    private static let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
}

#if DEBUG
struct BookingRequestCell_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestCell(request: .stub)
            .padding(.horizontal, .grid(3))
            .previewLayout(.sizeThatFits)
    }
}
#endif
