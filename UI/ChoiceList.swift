import SwiftUISugar

struct ChoiceList<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    typealias Element = Data.Element

    let data: Data
    let id: KeyPath<Element, ID>
    @Binding
    var selection: Element?
    @ViewBuilder
    let content: (Element, SelectableContainerState) -> Content

    var body: some View {
        LazyVStack(spacing: .grid(3)) {
            ForEach(data, id: id) { element in
                let isSelected = element[keyPath: id] == selection?[keyPath: id]
                ChoiceItemView(isSelected: isSelected) { state in
                    content(element, state)
                }
                .animation(.rythmicoSpring(duration: .durationShort), value: isSelected)
                .onTapGesture { selection = element }
            }
        }
    }
}

extension ChoiceList where Content == AnyView {
    init(
        data: Data,
        id: KeyPath<Element, ID>,
        selection: Binding<Element?>,
        content: @escaping (Element) -> String
    ) {
        self.init(data: data, id: id, selection: selection) { element, state in
            AnyView(
                Text(content(element))
                    .rythmicoTextStyle(state.isSelected ? .bodyBold : .bodyMedium)
                    .minimumScaleFactor(0.7)
            )
        }
    }
}

#if DEBUG
struct SelectableList_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreview(Int?.none) { selection in
            ChoiceList(data: [1, 2, 3, 4, 5], id: \.self, selection: selection) {
                "Option \($0)"
            }
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
#endif
