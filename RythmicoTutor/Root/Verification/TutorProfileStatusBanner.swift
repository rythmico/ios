import TutorDO
import SwiftUIEncore

struct TutorProfileStatusBanner: View {
    var status: TutorDTO.ProfileStatus

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: .grid(7)) {
                if let image = status.image {
                    Image(decorative: image.name)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, .grid(8))
                }
                VStack(spacing: .grid(5)) {
                    Text(status.title)
                        .font(.title3.bold())
                        .transition(.opacity)
                        .id(status.title.hashValue)
                    Text(status.description)
                        .transition(.opacity)
                        .id(status.description.hashValue)
                }
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.center)
                .lineSpacing(.grid(1))
                .frame(maxWidth: .grid(.max))
                .padding(.horizontal, .grid(10))

                if let openInboxAction = openInboxAction {
                    Button("Open Inbox", action: openInboxAction)
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.vertical, .grid(6))

            if let letsGoAction = letsGoAction {
                FloatingView {
                    RythmicoButton("Let's Go", style: .primary(), action: letsGoAction)
                }
            }
        }
        .minimumScaleFactor(.leastNonzeroMagnitude)
    }

    var foregroundColor: Color {
        Color(light: 0x19212C, dark: 0xFFFFFF)
    }

    var openInboxAction: Action? {
        switch status {
        case .interviewPending:
            return { Current.urlOpener.open("message://") }
        case .registrationPending, .interviewFailed, .verified:
            return nil
        }
    }

    var letsGoAction: Action? {
        status == .verified
            ? { Current.settings.tutorVerified = true }
            : nil
    }
}

private extension TutorDTO.ProfileStatus {
    var image: ImageAsset? {
        switch self {
        case .registrationPending:
            return nil
        case .interviewPending:
            return Asset.graphicsVerificationInterview
        case .interviewFailed:
            return Asset.graphicsVerificationFailure
        case .verified:
            return Asset.graphicsVerificationSuccess
        }
    }

    var title: String {
        switch self {
        case .registrationPending:
            return .empty
        case .interviewPending:
            return "Hi there!"
        case .interviewFailed:
            return "Your interview was unsuccessful"
        case .verified:
            return "Success!"
        }
    }

    var description: String {
        switch self {
        case .registrationPending:
            return .empty
        case .interviewPending:
            return "Thanks for signing up to Rythmico! Before we welcome you onto the platform, we’d love to get to know you better. Please follow the link sent to your inbox to book a quick online meeting."
        case .interviewFailed:
            return "Unfortunately we don’t think you’re ready for our platform at the moment. Please don’t be disheartened, we really appreciate you taking the time to apply and hope that you will consider us again in the future."
        case .verified:
            return "Your profile has been verified. Thank you for your patience. You can now start using Rythmico Tutor 🥳"
        }
    }
}

#if DEBUG
struct TutorProfileStatusBanner_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TutorProfileStatusBanner(status: .interviewPending)
            TutorProfileStatusBanner(status: .interviewFailed)
            TutorProfileStatusBanner(status: .verified)
        }
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
