import SwiftUI

struct InfoDisclaimerButton: View {
    var title: String
    var message: String

    @State
    private var showingDisclaimer = false

    var body: some View {
        Image(decorative: Asset.iconInfo.name)
            .renderingMode(.template)
            .foregroundColor(.rythmicoGray90)
            .alert(isPresented: $showingDisclaimer) {
                Alert(title: Text(title), message: Text(message))
            }
            .onTapGesture { showingDisclaimer = true }
    }
}
