import SwiftUI

struct ExpandableText<Expander: View, Collapser: View>: View {
    // Indicates whether the user want to see all the text or not
    @State private var expanded: Bool = false
    // Indicates whether the string provided overgrows the threshold line limit
    @State private var isExpandable: Bool = false

    private var content: String
    private var thresholdLines: Int
    private var expander: Expander
    private var collapser: Collapser

    init(
        _ content: String,
        thresholdLines: Int = 3,
        @ViewBuilder expander: () -> Expander,
        @ViewBuilder collapser: () -> Collapser
    ) {
        self.content = content
        self.thresholdLines = thresholdLines
        self.expander = expander()
        self.collapser = collapser()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: lineSpacing) {
            // Render the real text (which might or might not be limited)
            Text(content)
                .lineLimit(lineLimit)
                .lineSpacing(lineSpacing)
                .background(
                    // Render the limited text and measure its size
                    Text(content)
                        .lineLimit(thresholdLines)
                        .lineSpacing(lineSpacing)
                        .background(
                            GeometryReader { displayedGeometry in
                                // Create a ZStack with unbounded height to allow the inner Text as much
                                // height as it likes, but no extra width.
                                ZStack {
                                    // Render the text without restrictions and measure its size
                                    Text(content)
                                        .lineSpacing(lineSpacing)
                                        .background(
                                            GeometryReader { fullGeometry in
                                                // And compare the two
                                                Color.clear.onAppear {
                                                    isExpandable = fullGeometry.size.height > displayedGeometry.size.height
                                                }
                                            }
                                        )
                                }
                                .frame(height: .greatestFiniteMagnitude)
                            }
                        )
                        .hidden() // Hide the background
            )

            if isExpandable { toggleButton }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: expanded)
    }

    private var lineLimit: Int? {
        expanded ? nil : thresholdLines
    }

    private let lineSpacing = .spacingUnit * 2

    @ViewBuilder
    private var toggleButton: some View {
        Button(action: { expanded.toggle() }) {
            if expanded {
                collapser
            } else {
                expander
            }
        }
    }
}

extension ExpandableText where Expander == Text, Collapser == Text {
    init(
        _ content: String,
        thresholdLines: Int = 3,
        expander: String = "Read More",
        collapser: String = "Read Less"
    ) {
        self.init(
            content,
            thresholdLines: thresholdLines,
            expander: { Text(expander).fontWeight(.bold) },
            collapser: { Text(collapser).fontWeight(.bold) }
        )
    }
}
