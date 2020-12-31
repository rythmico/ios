import SwiftUI

struct PageView<Data: RandomAccessCollection, Selection: Hashable, Content: View>: View where Data.Element == Selection {
    private var data: Data
    @Binding
    private var selection: Selection
    @State
    private var privateSelection: Selection
    private var accentColor: Color
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        selection: Binding<Selection>? = nil,
        accentColor: Color,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        if let selection = selection {
            self._selection = selection
            self._privateSelection = .init(wrappedValue: selection.wrappedValue)
        } else if let firstElement = data.first {
            let privateSelection = State(wrappedValue: firstElement)
            self._selection = privateSelection.projectedValue
            self._privateSelection = privateSelection
        } else {
            preconditionFailure("PageView initialized without selection binding and empty data collection.")
        }
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
