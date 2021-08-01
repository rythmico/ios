import SwiftUISugar

struct SectionHeaderContentView<Accessory: View, Content: View>: View {
    let title: Text
    let style: Style
    let accessory: Accessory
    @ViewBuilder
    let content: Content

    init(
        _ title: Text,
        style: Style,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.style = style
        self.accessory = accessory()
        self.content = content()
    }

    var body: some View {
        Container(style: style.containerStyle) {
            VStack(alignment: .leading, spacing: style.verticalSpacing) {
                HStack(alignment: .center, spacing: .grid(2.5)) {
                    header
                    accessory
                }
                content
            }
            .padding(style.padding)
        }
        .frame(maxWidth: .grid(.max))
    }

    @ViewBuilder
    private var header: some View {
        title
            .rythmicoTextStyle(.bodyBold)
            .foregroundColor(.rythmico.foreground)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension SectionHeaderContentView {
    init<S: StringProtocol>(
        _ title: S,
        style: Style,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder content: () -> Content
    ) {
        self.init(Text(title), style: style, accessory: accessory, content: content)
    }
}

extension SectionHeaderContentView where Accessory == EmptyView {
    init(_ title: Text, style: Style, @ViewBuilder content: () -> Content) {
        self.init(title, style: style, accessory: EmptyView.init, content: content)
    }

    init<S: StringProtocol>(_ title: S, style: Style, @ViewBuilder content: () -> Content) {
        self.init(Text(title), style: style, content: content)
    }
}

extension SectionHeaderContentView {
    enum Style: Hashable {
        case plain
        case box

        var containerStyle: ContainerStyle {
            switch self {
            case .plain: return .plain
            case .box: return .box
            }
        }

        var verticalSpacing: CGFloat {
            switch self {
            case .plain: return .grid(3)
            case .box: return .grid(4)
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .plain: return .zero
            case .box: return .init(top: .grid(4), leading: .grid(4), bottom: .grid(5), trailing: .grid(4))
            }
        }
    }
}

#if DEBUG
struct SectionHeaderContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SectionHeaderContentView("Hello World", style: .box, accessory: { Text("Edit") }) {
                Text("Foo bar baz")
            }
            SectionHeaderContentView("Hello World", style: .box, accessory: { Text("Edit").frame(maxWidth: .infinity, alignment: .leading) }) {
                Text("Foo bar baz")
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
