import SwiftUI

struct TitleCell: View {
    var title: String
    var detail: String

    var body: some View {
        HStack(spacing: .spacingSmall) {
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
            Spacer()
            Text(detail)
                .foregroundColor(.secondary)
                .font(.body)
        }
    }
}
