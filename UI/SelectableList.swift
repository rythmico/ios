import SwiftUI

struct SelectableList<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    @Binding
    private var selection: Data.Element?
    private let content: (Data.Element) -> Content

    init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        selection: Binding<Data.Element?>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self._selection = selection
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider().foregroundColor(.rythmicoGray20)
            ForEach(data, id: id) { element in
                VStack(spacing: 0) {
                    Button(action: { selection = element }) {
                        HStack(spacing: 0) {
                            content(element)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(.label))
                            Spacer()
                            if isSelected(element) {
                                Image(decorative: Asset.iconCheckmark.name)
                                    .renderingMode(.template)
                                    .foregroundColor(.accentColor)
                                    .transition(
                                        AnyTransition
                                            .opacity
                                            .animation(.easeInOut(duration: .durationShort))
                                    )
                            }
                        }
                        .padding(.spacingMedium)
                    }
                    Divider().foregroundColor(.rythmicoGray20)
                }
            }
        }
    }

    private func isSelected(_ element: Data.Element) -> Bool {
        guard let selectedElementId = selection?[keyPath: id] else {
            return false
        }
        let elementId = element[keyPath: id]
        return elementId == selectedElementId
    }
}

extension SelectableList where Data.Element: Identifiable, ID == Data.Element.ID {
    init(
        _ data: Data,
        selection: Binding<Data.Element?>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.init(data, id: \.id, selection: selection, content: content)
    }
}

#if DEBUG
struct SelectableList_Previews: PreviewProvider {
    struct Preview: View {
        @State var selection: Int?

        var body: some View {
            SelectableList([1, 2, 3, 4, 5], id: \.self, selection: $selection) { number in
                Text("Cell \(number)")
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
