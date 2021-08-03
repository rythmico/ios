import SwiftUISugar

struct SelectableLazyVGrid<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    typealias Element = Data.Element

    let data: Data
    let id: KeyPath<Element, ID>
    var columns: Int = 2
    let action: (Element) -> Void
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
