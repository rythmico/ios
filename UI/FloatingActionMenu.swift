import SwiftUIEncore

struct FloatingActionMenu: View {
    struct Button {
        var title: String
        var isPrimary: Bool = false
        var action: Action
    }

    private var head: Button
    private var tail: [Button]

    init?(_ buttons: [Button]) {
        guard let head = buttons.first else { return nil }
        self.head = head
        self.tail = buttons.dropFirst().reversed() // TODO: reversed() needed cause Menu shows actions in reverse order. Check if fixed in iOS 15.
    }

    var body: some View {
        FloatingView {
            HStack(spacing: .grid(4), content: actionButtons)
        }
    }

    @ViewBuilder
    private func actionButtons() -> some View {
        head.view()

        if tail.count == 1 {
            tail.first?.view()
        } else if tail.count > 1 {
            Menu {
                ForEach(0..<tail.count, id: \.self) {
                    if let button = tail[safe: $0] {
                        SwiftUI.Button(button.title, action: button.action)
                    }
                }
            } label: {
                RythmicoButton("More...", style: .tertiary(), action: {})
            }
        }
    }
}

private extension FloatingActionMenu.Button {
    @ViewBuilder
    func view() -> some View {
        RythmicoButton(title, style: isPrimary ? .secondary() : .tertiary(), action: action)
    }
}

#if DEBUG
struct FloatingActionMenu_Previews: PreviewProvider {
    static var buttons: [[FloatingActionMenu.Button]] {
        [
            [
                .init(title: "View Plan", isPrimary: true, action: {}),
            ],
            [
                .init(title: "View Plan", isPrimary: false, action: {}),
            ],
            [
                .init(title: "No", isPrimary: true, action: {}),
                .init(title: "Yes", isPrimary: false, action: {}),
            ],
            [
                .init(title: "Reschedule Plan", isPrimary: false, action: {}),
                .init(title: "Cancel Plan", isPrimary: false, action: {}),
            ],
            [
                .init(title: "View Plan", isPrimary: true, action: {}),
                .init(title: "Reschedule Plan", isPrimary: false, action: {}),
                .init(title: "Cancel Plan Request", isPrimary: false, action: {}),
            ],
        ]
    }

    static var previews: some View {
        ForEach(0..<buttons.count, id: \.self) { let buttons = buttons[$0]
            FloatingActionMenu(buttons)
        }
        .previewLayout(.sizeThatFits)
        .padding(.top, 100)
    }
}
#endif
