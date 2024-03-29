import SwiftUIEncore

struct CollectionView<Content: View>: View {
    var topPadding: CGFloat = .grid(4)
    @ViewBuilder
    var content: Content

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: .grid(4)) {
                content
            }
            .frame(maxWidth: .grid(.max))
            .padding(.top, topPadding)
            .padding([.horizontal, .bottom], .grid(4))
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
            ForEach(data, id: id, content: content).eraseToAnyView()
        }
    }

    init<Data: RandomAccessCollection, ID, Subcontent: View>(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Subcontent
    ) where Data.Element: Identifiable, ID == Data.Element.ID {
        self.init {
            ForEach(data, id: \.id, content: content).eraseToAnyView()
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
