import SwiftUIEncore

struct ProfileContactUsCell: View {
    var body: some View {
        ProfileCell("Contact Us", disclosure: true) {
            Current.urlOpener.open("mailto:info@rythmico.com")
        }
    }
}
