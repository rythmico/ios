import SwiftUI

struct RoundedShadowContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.rythmicoWhite)
            .cornerRadius(10, antialiased: true)
            .shadow(color: Color(white: 0, opacity: 0.14), radius: 5, x: 0, y: 2)
    }
}
