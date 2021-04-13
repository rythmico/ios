import SwiftUI

struct ErrorText: View {
    var error: Error

    init(_ error: Error) {
        self.error = error
    }

    var body: some View {
        Text(error.localizedDescription)
            .rythmicoTextStyle(.callout)
            .foregroundColor(.rythmicoRed)
            .frame(maxWidth: .infinity, alignment: .leading)
            .transition(.offset(y: -.spacingMedium) + .opacity)
    }
}
