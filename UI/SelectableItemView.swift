import SwiftUISugar

struct SelectableItemView<Content: View>: View {
    let action: Action
    @ViewBuilder
    let content: Content

    var body: some View {
        AdHocButton(action: action) { state in
            SelectableContainer(isSelected: state == .pressed) { _ in
                content
                    .padding(.top, .grid(5))
                    .padding([.horizontal, .bottom], .grid(4))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
