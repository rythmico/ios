import UIKit

// TODO: check if SVG still blurry without resize in SwiftUI 3.
extension UIImage {
    convenience init(_ solidColor: UIColor, size: CGSize = .init(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        solidColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgImage = image?.cgImage {
            self.init(cgImage: cgImage)
        } else if let ciImage = image?.ciImage {
            self.init(ciImage: ciImage)
        } else {
            fatalError("Impossible: no CGImage *nor* CIImage found")
        }
    }

    func resized(width: CGFloat? = nil, height: CGFloat? = nil) -> UIImage {
        guard let size = size(width: width, height: height) else {
            return self
        }
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    private func size(width: CGFloat?, height: CGFloat?) -> CGSize? {
        switch (width, height) {
        case (let width?, let height?):
            return CGSize(width: width, height: height)
        case (let width?, nil):
            return CGSize(width: width, height: width / size.ratio)
        case (nil, let height?):
            return CGSize(width: height * size.ratio, height: height)
        case (nil, nil):
            return nil
        }
    }
}

private extension CGSize {
    var ratio: CGFloat { width / height }
}
