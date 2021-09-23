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
            .foregroundColor(.rythmico.foreground)
            .multilineTextAlignment(.leading)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, TitleContentViewHorizontalPadding.leading - UITableViewCell.defaultHorizontalPadding)
            .padding(.trailing, TitleContentViewHorizontalPadding.trailing - UITableViewCell.defaultHorizontalPadding)
            .padding(.bottom, .grid(1))
    }
}
