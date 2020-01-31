import SwiftUI
import Then

struct ActivityIndicator: UIViewRepresentable {

    var style: UIActivityIndicatorView.Style
    var color: UIColor? = nil

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style).then {
            $0.color = color ?? $0.color
            $0.startAnimating()
        }
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {}
}
