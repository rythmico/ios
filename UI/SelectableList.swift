import SwiftUI

struct SelectableList<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    var data: Data
    var id: KeyPath<Data.Element, ID>
    @Binding
    var selection: Data.Element?
    @ViewBuilder
    var content: (Data.Element) -> Content

    var body: some View {
        VStack(spacing: 0) {
            Divider().overlay(Color.rythmicoGray20)
            ForEach(data, id: id) { element in
                VStack(spacing: 0) {
                    Button(action: { selection = element }) {
                        HStack(spacing: 0) {
                            content(element)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if isSelected(element) {
                                Image(decorative: Asset.iconCheckmark.name)
                                    .renderingMode(.template)
                                    .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
                            }
                        }
                        .padding(.spacingMedium)
                    }
                    Divider().overlay(Color.rythmicoGray20)
                }
                .background(InteractiveBackground())
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
        self.init(data: data, id: \.id, selection: selection, content: content)
    }
}

extension SelectableList where ID == String, Content == AnyView {
    init(
        _ data: Data,
        title: KeyPath<Data.Element, String>,
        selection: Binding<Data.Element?>
    ) {
        self.init(data: data, id: title, selection: selection) { element in
            AnyView(
                Text(element[keyPath: title])
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.rythmicoGray90)
            )
        }
    }
}

#if DEBUG
struct SelectableList_Previews: PreviewProvider {
    struct Preview: View {
        @State var selection: Int?

        var body: some View {
            SelectableList(data: [1, 2, 3, 4, 5], id: \.self, selection: $selection) { number in
                Text("Cell \(number)")
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
