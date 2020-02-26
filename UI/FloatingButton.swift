import SwiftUI
import Sugar

struct FloatingButton: View {
    var title: String
    var action: Action

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(title).rythmicoFont(.callout).foregroundColor(.rythmicoWhite)
                    Spacer()
                }
                .padding(.vertical, .spacingSmall)
                .frame(minHeight: 44)
                .background(Color.rythmicoPurple.cornerRadius(4))
            }
            .padding(.vertical, .spacingExtraSmall)
            .padding(.horizontal, .spacingMedium)
        }
        .background(Color.rythmicoBackgroundSecondary.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edge: .bottom))
    }
}
