import SwiftUI

struct ProfileSection<Content: View>: View {
    var title: String
    var content: () -> Content

    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        Section(header: header, content: content).textCase(nil)
    }

    @ViewBuilder
    var header: some View {
        Text(title)
            .rythmicoTextStyle(.subheadlineBold)
            .foregroundColor(.rythmicoForeground)
            .padding(.horizontal, .spacingMedium - UITableViewCell.defaultHorizontalPadding)
            .padding(.bottom, .spacingUnit * 2)
    }
}
