import SwiftUI

extension View {
    func withSmallDBSCheck() -> some View {
        self.modifier(ImageOverlayModifier(image: Asset.iconDbsSmall.image, alignment: .bottom))
    }

    func withDBSCheck() -> some View {
        self.modifier(ImageOverlayModifier(image: Asset.iconDbs.image, alignment: .bottom))
    }
}

struct ImageOverlayModifier: ViewModifier {
    var image: UIImage
    var alignment: Alignment

    func body(content: Content) -> some View {
        content.overlay(Image(uiImage: image).offset(offset), alignment: alignment)
    }

    private var offset: CGSize {
        switch alignment {
        case .top:
            return CGSize(width: 0, height: -halfImageHeight)
        case .topLeading:
            return CGSize(width: -halfImageWidth, height: -halfImageHeight)
        case .topTrailing:
            return CGSize(width: halfImageWidth, height: -halfImageHeight)
        case .center:
            return .zero
        case .leading:
            return CGSize(width: -halfImageWidth, height: 0)
        case .trailing:
            return CGSize(width: halfImageWidth, height: 0)
        case .bottom:
            return CGSize(width: 0, height: halfImageHeight)
        case .bottomLeading:
            return CGSize(width: -halfImageWidth, height: halfImageHeight)
        case .bottomTrailing:
            return CGSize(width: halfImageWidth, height: halfImageHeight)
        default:
            assertionFailure("Unsupported alignment '\(alignment)' in \(#file):\(#line)")
            return .zero
        }
    }

    private var halfImageWidth: CGFloat { image.size.width / 2 }
    private var halfImageHeight: CGFloat { image.size.height / 2 }
}
