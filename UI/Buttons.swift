import SwiftUI
import Sugar

extension Button {
    func primaryStyle() -> some View {
        buttonStyle(PrimaryButtonStyle())
    }

    func secondaryStyle() -> some View {
        buttonStyle(SecondaryButtonStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rythmicoFont(.bodyBold)
            .foregroundColor(.rythmicoWhite)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(backgroundColor(for: configuration))
            )
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoHighlightPurple
            : Color.rythmicoPurple
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, .spacingMedium)
            .rythmicoFont(.bodyBold)
            .foregroundColor(foregroundColor(for: configuration))
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(backgroundColor(for: configuration))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.rythmicoGray30, lineWidth: 2)
                    )
            )
    }

    func foregroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoWhite
            : Color.rythmicoGray90
    }

    func backgroundColor(for configuration: Configuration) -> Color {
        configuration.isPressed
            ? Color.rythmicoGray30
            : Color.clear
    }
}

#if DEBUG
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Button("Next", action: {}).primaryStyle()
            Button("Next", action: {}).secondaryStyle()
        }
        .padding()
    }
}
#endif
