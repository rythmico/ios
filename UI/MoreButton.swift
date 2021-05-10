import SwiftUI
import FoundationSugar

struct MoreButton: View {
    struct Button {
        var title: String
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
                    SwiftUI.Button(button.title, action: button.action)
                }
            }
        } label: {
            ThreeDotButton(action: {})
        }
    }
}

struct ThreeDotButton: View {
    static let uiImage = UIImage(systemSymbol: .ellipsisCircle).applyingSymbolConfiguration(.init(pointSize: 17, weight: .medium, scale: .large))!
    static let image: some View = Image(systemSymbol: .ellipsisCircle).font(.system(size: 17, weight: .medium)).imageScale(.large)

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
            .init(title: "Action A", action: {}),
            .init(title: "Action B", action: {}),
        ])
        .previewLayout(.sizeThatFits)
    }
}
#endif
