import SwiftUI
import FoundationSugar

struct ExpandableText<Expander: View, Collapser: View>: View {
    @State
    private var isExpanded = false

    var content: String
    @ViewBuilder
    var expander: Expander
    @ViewBuilder
    var collapser: Collapser
    var onExpand: Action? = nil
    var onCollapse: Action? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            VStack(alignment: .leading, spacing: paragraphSpacing) {
                ForEach(0..<paragraphCount, id: \.self) { index in
                    Text(paragraphs[index])
                        .lineSpacing(lineSpacing)
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

    private let paragraphSpacing: CGFloat = .spacingLarge
    private let paragraphCountWhenCollapsed = 1
    private var paragraphCount: Int { isExpanded ? paragraphs.count : min(paragraphCountWhenCollapsed, paragraphs.count) }
    private var paragraphs: [String] { content.removingRepetitionOf("\n").components(separatedBy: "\n") }

    private let lineSpacing: CGFloat = .spacingUnit * 2

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
}

extension ExpandableText where Expander == Text, Collapser == Text {
    init(
        content: String,
        expander: String = "Read More",
        collapser: String = "Read Less",
        onExpand: Action? = nil,
        onCollapse: Action? = nil
    ) {
        self.init(
            content: content,
            expander: { Text(expander).fontWeight(.bold) },
            collapser: { Text(collapser).fontWeight(.bold) },
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
