import SwiftUI
import Sugar

struct TutorStatusBanner: View {
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    var status: TutorStatus

    var body: some View {
        VStack(spacing: .spacingUnit * 12) {
            Image(decorative: Asset.appLogo.name)
                .resizable()
                .scaledToFit()
                .frame(width: 68)
            Text(status.description)
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.center)
                .lineSpacing(.spacingUnit)
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingUnit * 10)
                .transition(.opacity)
                .id(status.description.hashValue)
            enableNotificationsAction.map { Button("Notify Me", action: $0) }
        }
        .animation(.rythmicoSpring(duration: .durationMedium), value: enableNotificationsAction != nil)
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

private extension TutorStatus {
    var description: String {
        switch self {
        case .notCurated:
            return  """
                    Thank you for signing up as a Rythmico Tutor.

                    We will review your submission and reach out to you within a few days.
                    """
        case .notDBSChecked:
            return  """
                    Your mandatory DBS check form is now ready.

                    Please follow the link sent to your inbox provided by uCheck.
                    """
        case .notRegistered, .verified:
            return .empty
        }
    }
}

#if DEBUG
struct TutorStatusBanner_Previews: PreviewProvider {
    static var previews: some View {
        TutorStatusBanner(status: .notCurated)
    }
}
#endif
