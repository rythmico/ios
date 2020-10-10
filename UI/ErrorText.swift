import SwiftUI

struct ErrorText: View {
    var error: Error

    init(_ error: Error) {
        self.error = error
    }

    var body: some View {
        Text(error.localizedDescription)
            .rythmicoFont(.callout)
            .foregroundColor(.rythmicoRed)
            .frame(maxWidth: .infinity, alignment: .leading)
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .offset(x: 0, y: -.spacingMedium))
            )
    }
}
