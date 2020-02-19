import SwiftUI

struct CollectionView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let topPadding: CGFloat?
    private let spacing: CGFloat?
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        topPadding: CGFloat? = 12,
        spacing: CGFloat? = 12,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.topPadding = topPadding
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                ForEach(data, id: id, content: content)
            }
            .padding(.top, topPadding)
        }
    }
}
