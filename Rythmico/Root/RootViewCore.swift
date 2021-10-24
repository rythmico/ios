import SwiftUIEncore

extension RootView {
    func handleStateChanges() {
        if let siwaUserID = Current.keychain.siwaUserInfo?.userID {
            Current.siwaCredentialStateProvider.getCredentialState(forUserID: siwaUserID) { state in
                switch state {
                case .revoked, .transferred:
                    Current.userCredentialProvider.userCredential = nil
                case .authorized, .notFound:
                    break
                @unknown default:
                    break
                }
            }
        }

        Current.siwaCredentialRevocationNotifier.revocationHandler = {
            Current.userCredentialProvider.userCredential = nil
        }
    }
}
