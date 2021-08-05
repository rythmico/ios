import SwiftUISugar

struct OptionsButton: View {
    var buttons: [ContextMenuButton]

    init(_ buttons: [ContextMenuButton]) {
        self.buttons = buttons
    }

    var body: some View {
        ContextMenuView(buttons) { Text("Options").rythmicoTextStyle(.bodyMedium) }
    }
}

struct MoreButton: View {
    var buttons: [ContextMenuButton]

    init(_ buttons: [ContextMenuButton]) {
        self.buttons = buttons
    }

    var body: some View {
        ContextMenuView(buttons) { ThreeDotButton(action: {}) }
    }
}

// TODO: formalize.
struct ThreeDotButton: View {
    static let uiImage = UIImage(systemSymbol: .ellipsisCircleFill).applyingSymbolConfiguration(.init(pointSize: 18, weight: .medium, scale: .large))!
    static let image: some View = Image(systemSymbol: .ellipsisCircleFill).font(.system(size: 18, weight: .medium)).imageScale(.large)

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Self.image.padding([.vertical, .leading], .grid(4))
        }
        .foregroundColor(.accentColor)
    }
}

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

#if DEBUG
struct MoreButton_Previews: PreviewProvider {
    static var previews: some View {
        MoreButton([
            .init(title: "Action A", icon: Asset.Icon.Action.reschedule, action: {}),
            .init(title: "Action B", icon: Asset.Icon.Action.cancel, action: {}),
        ])
        .previewLayout(.sizeThatFits)
    }
}
#endif
