import SwiftUI
import Sugar

struct ActionList: View {
    struct Button {
        var title: String
        var disclosure: Bool = false
        var action: Action
    }

    private var buttons: [Button]
    private var showBottomSeparator: Bool

    init(_ buttons: [Button], showBottomSeparator: Bool) {
        self.buttons = buttons
        self.showBottomSeparator = showBottomSeparator
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider().foregroundColor(.rythmicoGray20)
            ForEach(0..<buttons.count) { index in
                VStack(spacing: 0) {
                    SwiftUI.Button(action: self.buttons[index].action) {
                        HStack(spacing: 0) {
                            Text(self.buttons[index].title)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if self.buttons[index].disclosure {
                                Image(decorative: Asset.iconDisclosure.name)
                                    .renderingMode(.template)
                            }
                        }
                        .padding(.vertical, .spacingLarge)
                        .padding(.horizontal, .spacingMedium)
                    }
                    if self.isLastButtonIndex(index) && !self.showBottomSeparator {
                        EmptyView()
                    } else {
                        Divider().foregroundColor(.rythmicoGray20)
                    }
                }
            }
        }
    }

    private func isLastButtonIndex(_ index: Int) -> Bool {
        index == buttons.endIndex - 1
    }
}

struct ActionList_Previews: PreviewProvider {
    static var previews: some View {
        ActionList(
            [
                .init(title: "View Lesson Plan", disclosure: true, action: {}),
                .init(title: "Cancel Lesson Plan Request", disclosure: false, action: {})
            ],
            showBottomSeparator: false
        )
    }
}
