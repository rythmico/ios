import SwiftUI

struct PageView<Data: RandomAccessCollection, Selection: Hashable, Content: View>: View where Data.Element == Selection {
    private var data: Data
    @Binding
    private var selection: Selection
    private var accentColor: Color
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        selection: Binding<Selection>,
        accentColor: Color,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self._selection = selection
        self.accentColor = accentColor
        self.content = content
    }

    var body: some View {
        VStack(spacing: .spacingMedium) {
            TabView(selection: $selection) {
                ForEach(data, id: \.self) { content($0).tag($0) }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            PageDotIndicator(
                selection: $selection,
                items: data,
                foregroundColor: accentColor.opacity(0.125),
                accentColor: accentColor
            )
        }
    }
}
