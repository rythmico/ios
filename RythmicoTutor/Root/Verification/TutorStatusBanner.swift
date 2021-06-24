import SwiftUI
import FoundationSugar

struct TutorStatusBanner: View {
    var status: TutorStatus

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
                        .font(.system(size: 19, weight: .bold))
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
                    Button("Let's Go", action: letsGoAction).primaryStyle()
                }
            }
        }
    }

    var foregroundColor: Color {
        Color(light: 0x19212C, dark: .white)
    }

    var openInboxAction: Action? {
        switch status {
        case .interviewPending, .dbsPending:
            return { Current.urlOpener.open("message://") }
        case .registrationPending, .interviewFailed, .dbsProcessing, .dbsFailed, .verified:
            return nil
        }
    }

    var letsGoAction: Action? {
        status == .verified
            ? { Current.settings.tutorVerified = true }
            : nil
    }
}

private extension TutorStatus {
    var image: ImageAsset? {
        switch self {
        case .registrationPending:
            return nil
        case .interviewPending:
            return Asset.graphicsVerificationInterview
        case .dbsPending, .dbsProcessing:
            return Asset.graphicsVerificationDbs
        case .interviewFailed, .dbsFailed:
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
        case .dbsPending:
            return "DBS Check required"
        case .dbsProcessing:
            return "Your DBS Check is processing"
        case .interviewFailed:
            return "Your interview was unsuccessful"
        case .dbsFailed:
            return "Your DBS Check was unsuccessful"
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
        case .dbsPending:
            return "Your mandatory DBS Check is awaiting. Please follow the link sent to your inbox to complete the DBS form provided by Sterling."
        case .dbsProcessing:
            return "Thank you for submitting your DBS Check form. We're awaiting the check results from Sterling and will update you as soon as possible."
        case .interviewFailed:
            return "Unfortunately we don’t think you’re ready for our platform at the moment. Please don’t be disheartened, we really appreciate you taking the time to apply and hope that you will consider us again in the future."
        case .dbsFailed:
            return "Unfortunately your DBS record did not match our requirements. If you think something is not right, please contact our DBS Check partner Sterling."
        case .verified:
            return "Your profile has been verified. Thank you for your patience. You can now start using Rythmico Tutor 🥳"
        }
    }
}

#if DEBUG
struct TutorStatusBanner_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TutorStatusBanner(status: .interviewPending)
            TutorStatusBanner(status: .interviewFailed)
            TutorStatusBanner(status: .dbsPending)
            TutorStatusBanner(status: .dbsProcessing)
            TutorStatusBanner(status: .dbsFailed)
            TutorStatusBanner(status: .verified)
        }
    }
}
#endif
