import SwiftUI
import Sugar

struct TutorStatusBanner: View {
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    var description: String

    init(_ description: String) {
        self.description = description
    }

    var body: some View {
        VStack(spacing: .spacingUnit * 12) {
            Image(decorative: Asset.appLogo.name)
                .resizable()
                .scaledToFit()
                .frame(width: 68)
            Text(description)
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.center)
                .lineSpacing(.spacingUnit)
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingUnit * 10)
                .transition(.opacity)
                .id(description.hashValue)
            enableNotificationsAction.map { Button("Notify Me", action: $0) }
        }
        .animation(.rythmicoSpring(duration: .durationShort), value: enableNotificationsAction != nil)
        .alert(
            error: pushNotificationAuthCoordinator.status.failedValue,
            dismiss: pushNotificationAuthCoordinator.dismissFailure
        )
    }

    var foregroundColor: Color {
        Color(
            UIColor(
                lightModeVariant: .init(hex: 0x19212C),
                darkModeVariant: .white
            )
        )
    }

    var enableNotificationsAction: Action? {
        pushNotificationAuthCoordinator.status.isDetermined
            ? nil
            : pushNotificationAuthCoordinator.requestAuthorization
    }
}

#if DEBUG
struct TutorStatusBanner_Previews: PreviewProvider {
    static var previews: some View {
        TutorStatusBanner(
            """
            Thank you for signing up as a Rythmico Tutor.

            We will review your submission and reach out to you within a few days.
            """
        )
    }
}
#endif
