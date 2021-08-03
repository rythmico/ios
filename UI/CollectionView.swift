import SwiftUI

struct CollectionView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: .grid(4)) {
                content
            }
            .frame(maxWidth: .grid(.max))
            .padding(.all, .grid(4))
        }
    }
}

extension CollectionView where Content == AnyView {
    init<Data: RandomAccessCollection, ID: Hashable, Subcontent: View>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Subcontent
    ) {
        self.init {
            AnyView(ForEach(data, id: id, content: content))
        }
    }

    init<Data: RandomAccessCollection, ID, Subcontent: View>(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Subcontent
    ) where Data.Element: Identifiable, ID == Data.Element.ID {
        self.init {
            AnyView(ForEach(data, id: \.id, content: content))
        }
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
