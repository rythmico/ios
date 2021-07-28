import SwiftUISugar

struct InfoDisclaimerButton: View {
    var title: String
    var message: String

    @State
    private var showingDisclaimer = false

    var body: some View {
        Button(action: { showingDisclaimer = true }) {
            Image(decorative: Asset.Icon.Label.info.name)
                .renderingMode(.template)
                .foregroundColor(.rythmico.gray90)
        }
        .offset(y: 0.5)
        .multiModal {
            $0.alert(isPresented: $showingDisclaimer) {
                Alert(title: Text(title), message: Text(message))
            }
        }
    }
}
