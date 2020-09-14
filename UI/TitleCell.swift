import SwiftUI

struct TitleCell: View {
    var title: String
    var detail: String

    var body: some View {
        HStack(spacing: .spacingSmall) {
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(detail)
                .foregroundColor(.secondary)
                .font(.body)
                .multilineTextAlignment(.trailing)
        }
    }
}
