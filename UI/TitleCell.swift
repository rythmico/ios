import SwiftUI

struct TitleCell: View {
    var title: String
    var titleColor: Color = .primary
    var detail: String
    var detailColor: Color = .secondary

    var body: some View {
        HStack(spacing: .spacingSmall) {
            Text(title)
                .foregroundColor(titleColor)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(detail)
                .foregroundColor(detailColor)
                .font(.body)
                .multilineTextAlignment(.trailing)
        }
    }
}
