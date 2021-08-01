import SwiftUISugar

// TODO: make generic over content
struct SelectableList<Data: RandomAccessCollection, ID: Hashable>: View {
    typealias Element = Data.Element

    let data: Data
    let id: KeyPath<Element, ID>
    @Binding
    var selection: Element?
    let content: (Element) -> String

    var body: some View {
        LazyVStack(spacing: .grid(3)) {
            ForEach(data, id: id) { element in
                SelectableContainer(content(element), isSelected: isSelected(element))
                    .animation(.rythmicoSpring(duration: .durationMedium), value: isSelected(element))
                    .onTapGesture { selection = element }
            }
        }
    }

    private func isSelected(_ element: Element) -> Bool {
        guard let selectedElementId = selection?[keyPath: id] else {
            return false
        }
        let elementId = element[keyPath: id]
        return elementId == selectedElementId
    }
}

#if DEBUG
struct SelectableList_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreview(Int?.none) { selection in
            SelectableList(data: [1, 2, 3, 4, 5], id: \.self, selection: selection) {
                "Option \($0)"
            }
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
#endif
