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
                // Needed cause otherwise SwiftUI does not refresh ScrollView. Sigh.
                if data.isEmpty {
                    Color.clear
                } else {
                    ForEach(data, id: id, content: content)
                }
            }
            .padding(padding)
        }
    }
}

extension CollectionView where Data.Element: Identifiable, ID == Data.Element.ID {
    init(
        _ data: Data,
        padding: EdgeInsets = .zero,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data, id: \.id, padding: padding, content: content)
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
