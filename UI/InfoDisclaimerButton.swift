import SwiftUISugar

struct InfoDisclaimerButton: View {
    var title: String
    var message: String

    @State
    private var showingDisclaimer = false

    var body: some View {
        Button(action: { showingDisclaimer = true }) {
            DynamicImage(asset: Asset.Icon.Label.info).foregroundColor(.rythmico.foreground)
        }
        .offset(y: 0.5)
        .multiModal {
            $0.alert(isPresented: $showingDisclaimer) {
                Alert(title: Text(title), message: Text(message))
            }
        }
    }
}
