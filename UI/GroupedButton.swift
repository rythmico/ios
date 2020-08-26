import SwiftUI

struct GroupedButton<Accessory: View>: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var title: String
    var alignment: TextAlignment
    var isDestructive: Bool
    var action: () -> Void
    var accessory: Accessory

    init(
        _ title: String,
        alignment: TextAlignment = .center,
        isDestructive: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.alignment = alignment
        self.isDestructive = isDestructive
        self.action = action
        self.accessory = accessory()
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .foregroundColor(labelColor)
                    .multilineTextAlignment(alignment)
                    .frame(maxWidth: .infinity)

                HStack {
                    Spacer()
                    accessory
                }
            }
        }
        .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }

    private var labelColor: Color? {
        isEnabled
            ? isDestructive ? .red : nil
            : .gray
    }
}
