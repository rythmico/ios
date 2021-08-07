import SwiftUISugar

struct ContextMenuButton {
    var title: String
    var icon: ImageAsset
    var action: Action
}

struct ContextMenuView<Content: View>: View {
    var buttons: [ContextMenuButton]
    var content: Content

    init(_ buttons: [ContextMenuButton], @ViewBuilder content: () -> Content) {
        self.buttons = buttons
        self.content = content()
    }

    var body: some View {
        Menu {
            ForEach(0..<buttons.count, id: \.self) {
                if let button = buttons[safe: $0] {
                    SwiftUI.Button(action: button.action) {
                        Label(button.title, image: button.icon.name)
                    }
                }
            }
        } label: {
            content
        }
    }
}
