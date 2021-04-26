import SwiftUI
import MultiModal

struct InfoDisclaimerButton: View {
    var title: String
    var message: String

    @State
    private var showingDisclaimer = false

    var body: some View {
        Button(action: { showingDisclaimer = true }) {
            Image(decorative: Asset.iconInfo.name)
                .renderingMode(.template)
                .foregroundColor(.rythmicoGray90)
        }
        .offset(y: 0.5)
        .multiModal {
            $0.alert(isPresented: $showingDisclaimer) {
                Alert(title: Text(title), message: Text(message))
            }
        }
    }
}
