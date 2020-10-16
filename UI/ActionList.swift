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
            Divider().overlay(Color.rythmicoGray20)
            ForEach(0..<buttons.count, id: \.self) { index in
                VStack(spacing: 0) {
                    SwiftUI.Button(action: buttons[index].action) {
                        HStack(spacing: 0) {
                            Text(buttons[index].title)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if buttons[index].disclosure {
                                VectorImage(asset: Asset.iconDisclosure)
                            }
                        }
                        .padding(.vertical, .spacingLarge)
                        .padding(.horizontal, .spacingMedium)
                        .frame(maxWidth: .spacingMax)
                    }
                    if isLastButtonIndex(index) && !showBottomSeparator {
                        EmptyView()
                    } else {
                        Divider().overlay(Color.rythmicoGray20)
                    }
                }
            }
        }
    }

    private func isLastButtonIndex(_ index: Int) -> Bool {
        index == buttons.endIndex - 1
    }
}

#if DEBUG
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
#endif
