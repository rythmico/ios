import SwiftUI

struct VectorImage: UIViewRepresentable {
    var name: String
    var resizeable: Bool = false
    var renderingMode: Image.TemplateRenderingMode? = .template
    var aspectRatio: ContentMode = .fit

    func makeUIView(context: Context) -> UIImageView {
        let uiImageRenderingMode = renderingMode.map(UIImage.RenderingMode.init) ?? .automatic
        let uiImage = UIImage(named: name)?.withRenderingMode(uiImageRenderingMode)
        if uiImage == nil {
            assertionFailure("Asset named '\(name)' not found.")
        }
        let uiView = UIImageView(image: uiImage)
        uiView.contentMode = UIView.ContentMode(aspectRatio)
        if !resizeable {
            uiView.setContentHuggingPriority(.required, for: .horizontal)
            uiView.setContentHuggingPriority(.required, for: .vertical)
        }
        return uiView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

extension UIView.ContentMode {
    init(_ contentMode: ContentMode) {
        switch contentMode {
        case .fit:
            self = .scaleAspectFit
        case .fill:
            self = .scaleAspectFill
        }
    }
}

extension UIImage.RenderingMode {
    init(_ renderingMode: Image.TemplateRenderingMode) {
        switch renderingMode {
        case .original:
            self = .alwaysOriginal
        case .template:
            self = .alwaysTemplate
        @unknown default:
            self = .automatic
        }
    }
}
