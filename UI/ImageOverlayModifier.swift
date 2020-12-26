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

#if DEBUG
struct ImageOverlayModifier_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(0..<Alignment.allCases.count, id: \.self) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
                .modifier(ImageOverlayModifier(image: Asset.iconDbsSmall.image, alignment: Alignment.allCases[$0]))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

private extension Alignment {
    static var allCases: [Self] {
        [.top, .topLeading, .topTrailing, .center, .leading, .trailing, .bottom, .bottomLeading, .bottomTrailing]
    }
}
#endif
