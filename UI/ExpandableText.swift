import SwiftUIEncore

struct ExpandableText<Expander: View, Collapser: View>: View {
    @State
    private var isExpanded = false

    var content: String
    var style: Font.RythmicoTextStyle = .body
    @ViewBuilder
    var expander: Expander
    @ViewBuilder
    var collapser: Collapser
    var onExpand: Action? = nil
    var onCollapse: Action? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(3)) {
            VStack(alignment: .leading, spacing: paragraphSpacing) {
                ForEach(0..<paragraphCount, id: \.self) { index in
                    Text(addEllipsisIfNeeded(paragraphs[index]))
                        .rythmicoTextStyle(style)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom) + .opacity,
                                removal: .identity
                            )
                        )
                }
            }

            toggleButton
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: isExpanded)
    }

    private let paragraphSpacing: CGFloat = .grid(5)
    private let paragraphCountWhenCollapsed = 1
    private var paragraphCount: Int { isExpanded ? paragraphs.count : min(paragraphCountWhenCollapsed, paragraphs.count) }
    private var paragraphs: [String] { content.components(separatedBy: "\n\n") }

    @ViewBuilder
    private var toggleButton: some View {
        if paragraphs.count > paragraphCountWhenCollapsed {
            Button(action: toggle) {
                if isExpanded {
                    collapser
                } else {
                    expander
                }
            }
        }
    }
    private func toggle() {
        (isExpanded ? onCollapse : onExpand)?()
        isExpanded.toggle()
    }

    private func addEllipsisIfNeeded(_ paragraph: String) -> String {
        guard !isExpanded else { return paragraph }
        switch true {
        case paragraph.hasSuffix("..."):
            return paragraph
        case paragraph.hasSuffix(".."):
            return paragraph + "."
        case paragraph.hasSuffix("."):
            return paragraph + ".."
        default:
            return paragraph + "..."
        }
    }
}

extension ExpandableText where Expander == AnyView, Collapser == AnyView {
    init(
        content: String,
        expander: String = "Read more",
        collapser: String = "Read less",
        onExpand: Action? = nil,
        onCollapse: Action? = nil
    ) {
        let text: (String) -> AnyView = {
            Text($0)
                .foregroundColor(.rythmico.picoteeBlue)
                .rythmicoTextStyle(.bodyBold)
                .eraseToAnyView()
        }
        self.init(
            content: content,
            expander: { text(expander) },
            collapser: { text(collapser) },
            onExpand: onExpand,
            onCollapse: onCollapse
        )
    }
}

#if DEBUG
struct ExpandableText_Previews: PreviewProvider {
    static let strings = ["", "Something", Portfolio.longStub.bio]

    static var previews: some View {
        ForEach(0..<strings.count, id: \.self) { index in
            ScrollView {
                ExpandableText(content: strings[index])
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
