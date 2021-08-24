import SwiftUIEncore

struct ProfileTermsAndPoliciesCell: View {
    var body: some View {
        ProfileCell("Terms and Policies", disclosure: true) {
            Current.urlOpener.openTermsAndConditionsURL()
        }
    }
}
