import SwiftUI
import Sugar

struct TutorStatusBanner: View {
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    var status: TutorStatus

    var body: some View {
        VStack(spacing: .spacingExtraLarge) {
            if let image = status.image {
                Image(decorative: image.name)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, .spacingUnit * 8)
            }
            VStack(spacing: .spacingMedium) {
                Text(status.title)
                    .font(.system(size: 19, weight: .bold))
                    .transition(.opacity)
                    .id(status.title.hashValue)
                Text(status.description)
                    .transition(.opacity)
                    .id(status.description.hashValue)
            }
            .foregroundColor(foregroundColor)
            .multilineTextAlignment(.center)
            .lineSpacing(.spacingUnit)
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingUnit * 10)
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
    var image: ImageAsset? {
        switch self {
        case .notCurated:
            return Asset.graphicsVerificationWaiting
        case .notDBSChecked:
            return Asset.graphicsVerificationWaiting
        case .notRegistered, .verified:
            return nil
        }
    }

    var title: String {
        switch self {
        case .notCurated:
            return "We’re reviewing your submission"
        case .notDBSChecked:
            return "We’re awaiting your DBS Check result"
        case .notRegistered, .verified:
            return .empty
        }
    }

    var description: String {
        switch self {
        case .notCurated:
            return "Thank you for signing up as a Rythmico Tutor. We will review your profile and reach out to you within a few days."
        case .notDBSChecked:
            return "Your mandatory DBS check form is pending your submission. Please follow the link sent to your inbox provided by uCheck."
        case .notRegistered, .verified:
            return .empty
        }
    }
}

#if DEBUG
struct TutorStatusBanner_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TutorStatusBanner(status: .notCurated)
            TutorStatusBanner(status: .notDBSChecked)
        }
        .previewDevices()
    }
}
#endif
