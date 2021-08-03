import SwiftUISugar

struct TitleSubtitleContentView<Content: View>: View {
    let title: String
    let subtitle: Text?
    let spacing: CGFloat
    @ViewBuilder
    var content: (_ padding: HorizontalInsets) -> Content

    init(
        _ title: String,
        _ subtitle: Text? = nil,
        spacing: CGFloat = .grid(6),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        VStack(spacing: spacing) {
            TitleContentView(title) { padding in
                subtitle?
                    .foregroundColor(.rythmico.foreground)
                    .rythmicoTextStyle(.body) // TODO: change to .subheadlineBold
                    .frame(maxWidth: .grid(.max), alignment: .leading)
                    .padding(padding)
                    .transition(.offset(y: -50) + .opacity)
                content(padding)
            }
        }
    }
}

extension TitleSubtitleContentView {
    init(
        _ title: String,
        _ subtitle: String,
        spacing: CGFloat = .grid(6),
        @ViewBuilder content: @escaping (_ padding: HorizontalInsets) -> Content
    ) {
        self.init(title, Text(subtitle), spacing: spacing, content: content)
    }
}

#if DEBUG
struct TitleSubtitleContentView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleContentView("Title", "Subtitle") { _ in
            Color.red
        }
    }
}
#endif
