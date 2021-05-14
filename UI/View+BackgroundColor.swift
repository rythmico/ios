import SwiftUI

extension View {
    func backgroundColor(_ color: Color) -> some View {
        self.background(color.edgesIgnoringSafeArea(.all))
    }
}
