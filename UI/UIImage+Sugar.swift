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

    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
