import SwiftUI
import Then

struct ActivityIndicator: View {
    private typealias Style = CircularProgressViewStyle

    var color: Color? = nil

    var body: some View {
        ProgressView().progressViewStyle(color.map(Style.init) ?? Style())
    }
}

#if DEBUG
struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(color: .black)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
