import SwiftUIEncore

struct ProfileRateUsOnAppStoreCell: View {
    var body: some View {
        ProfileCell("Rate us on the App Store", disclosure: true) {
            Current.urlOpener.openAppStorePageToWriteReview()
        }
    }
}
