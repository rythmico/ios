import SwiftUI

struct BookingApplicationGroupCell: View {
    private let status: BookingApplication.Status
    private let applicationCount: Int

    init(status: BookingApplication.Status, applications: [BookingApplication]) {
        self.status = status
        self.applicationCount = applications.filter { $0.statusInfo.status == status }.count
    }

    var body: some View {
        HStack(spacing: .spacingMedium) {
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
            Spacer()
            Text(accessory)
                .foregroundColor(.secondary)
                .font(.body)
        }
    }

    private var title: String {
        status.title
    }

    private var accessory: String {
        String(applicationCount)
    }
}

#if DEBUG
struct BookingApplicationGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationGroupCell(status: .selected, applications: .stub)
            .padding(.horizontal, .spacingExtraSmall)
            .previewLayout(.sizeThatFits)
    }
}
#endif
