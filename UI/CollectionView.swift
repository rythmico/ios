import SwiftUI

struct CollectionView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let padding: EdgeInsets
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        padding: EdgeInsets = .zero,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.padding = padding
        self.content = content
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .spacingSmall) {
                ForEach(data, id: id, content: content)
            }
            .padding(padding)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(["ss"], id: \.self) { title in
            ZStack {
                Color.red
                Text(title)
            }
        }
    }
}
