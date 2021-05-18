import SwiftUI
import FoundationSugar

struct MoreButton: View {
    struct Button {
        var title: String
        var icon: ImageAsset
        var action: Action
    }

    var buttons: [Button]

    init(_ buttons: [Button]) {
        self.buttons = buttons
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
            ThreeDotButton(action: {})
        }
    }
}

struct ThreeDotButton: View {
    static let uiImage = UIImage(systemSymbol: .ellipsisCircleFill).applyingSymbolConfiguration(.init(pointSize: 18, weight: .medium, scale: .large))!
    static let image: some View = Image(systemSymbol: .ellipsisCircleFill).font(.system(size: 18, weight: .medium)).imageScale(.large)

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Self.image.padding([.vertical, .leading], .spacingSmall)
        }
        .foregroundColor(.accentColor)
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
