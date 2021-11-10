import SwiftUI

struct ProfileLogOutCell: View {
    var body: some View {
        Button(action: logOut) {
            HStack(alignment: .center) {
                Text("Log out")
                    .rythmicoTextStyle(.body)
                    .foregroundColor(.rythmico.red)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(minHeight: 35)
        .accessibility(hint: Text("Double tap to log out of your account"))
    }

    func logOut() {
        Current.userCredentialProvider.userCredential = nil
        try! Current.keychain.removeAllObjects()
    }
}
