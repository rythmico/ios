import SwiftUISugar

struct SelectableLazyVGrid<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    typealias Element = Data.Element

    let data: Data
    let id: KeyPath<Element, ID>
    var columns: Int = 2
    let action: (Element) -> Void
    @ViewBuilder
    let content: (Element) -> Content

    var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(.flexible(minimum: 0, maximum: 200), spacing: .grid(3)),
                count: columns
            ),
            spacing: .grid(3)
        ) {
            ForEach(data, id: id) { element in
                SelectableItemView(action: { action(element) }) {
                    content(element)
                }
            }
        }
        .padding([.horizontal, .bottom], .grid(5))
    }
}

extension SelectableLazyVGrid where Data.Element: Identifiable, ID == Data.Element.ID {
    init(
        data: Data,
        columns: Int = 2,
        action: @escaping (Element) -> Void,
        @ViewBuilder content: @escaping (Element) -> Content
    ) {
        self.init(data: data, id: \.id, columns: columns, action: action, content: content)
    }
}
