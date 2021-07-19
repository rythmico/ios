import SwiftUI

struct BookingRequestCell: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    var request: BookingRequest

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
        "\(request.student.name) - \(request.instrument.standaloneName)"
    }

    private static let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private var subtitle: String {
        Self.scheduleFormatter.string(from: request.schedule.startDate)
    }

    private var accessory: String {
        request.postcode
    }

    private func goToDetail() {
        navigator.go(to: BookingRequestDetailScreen(bookingRequest: request), on: currentScreen)
    }
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
