import SwiftUI

extension Button {
    func primaryStyle(expansive: Bool = true) -> some View {
        buttonStyle(PrimaryButtonStyle(expansive: expansive))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var expansive: Bool

    func makeBody(configuration: Configuration) -> some View {
        DisableableButton {
            configuration.label
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, .spacingMedium)
                .font(Font.body.bold())
                .foregroundColor(.white)
                .frame(maxWidth: expansive ? .infinity : nil, minHeight: 50)
                .background(
                    RoundedRectangle(cornerRadius: .spacingUnit * 2, style: .continuous).fill(Color.blue)
                )
                .opacity(configuration.isPressed ? 0.3 : 1)
        }
    }
}

private struct DisableableButton<Button: View>: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var button: Button

    init(@ViewBuilder button: () -> Button) {
        self.button = button()
    }

    var body: some View {
        button
            .opacity(isEnabled ? 1 : 0.5)
            .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }
}
