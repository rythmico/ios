import SwiftUI

struct PageView<Data: RandomAccessCollection, Selection: Hashable, Content: View>: View where Data.Element == Selection {
    var data: Data
    @Binding
    var selection: Selection
    var fixedHeight: CGFloat? = nil
    var spacing: CGFloat = .grid(5)
    var accentColor: Color
    @ViewBuilder
    var content: (Data.Element) -> Content

    var body: some View {
        VStack(spacing: spacing) {
            TabView(selection: $selection) {
                ForEach(data, id: \.self) { content($0).tag($0) }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(idealHeight: fixedHeight)
            .fixedSize(horizontal: false, vertical: fixedHeight != nil)

            PageDotIndicator(
                selection: $selection,
                items: data,
                foregroundColor: accentColor.opacity(0.25),
                accentColor: accentColor
            )
        }
    }
}
