import SwiftUI

extension View {
    func centerH() -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: nil)
            self
            Spacer(minLength: nil)
        }
    }

    func centerV() -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: nil)
            self
            Spacer(minLength: nil)
        }
    }
}
