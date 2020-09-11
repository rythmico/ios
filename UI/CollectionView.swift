import SwiftUI

struct CollectionView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.content = content
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: .spacingSmall) {
                ForEach(data, id: id, content: content).padding(.horizontal, .spacingMedium)
            }
            .padding(.top, .spacingSmall)
            .padding(.bottom, .spacingMedium)
        }
    }
}

extension CollectionView where Data.Element: Identifiable, ID == Data.Element.ID {
    init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data, id: \.id, content: content)
    }
}

#if DEBUG
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
#endif
