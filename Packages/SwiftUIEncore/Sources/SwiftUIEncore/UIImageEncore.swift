extension UIImage {
    public static func dynamic(color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        let baseModeColor = color.resolvedColor(with: .init(userInterfaceStyle: .unspecified))
        let darkModeColor = color.resolvedColor(with: .init(userInterfaceStyle: .dark))

        guard baseModeColor != darkModeColor else {
            return UIImage(solidColor: baseModeColor, size: size)
        }

        let baseModeImage = UIImage(solidColor: baseModeColor, size: size)
        let darkModeImage = UIImage(solidColor: darkModeColor, size: size)
        baseModeImage.imageAsset?.register(darkModeImage, with: .init(userInterfaceStyle: .dark))
        return baseModeImage
    }

    public convenience init(solidColor color: UIColor, size: CGSize = .init(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        UIGraphicsGetCurrentContext()? => {
            $0.setFillColor(color.cgColor)
            $0.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            if let cgImage = image.cgImage {
                self.init(cgImage: cgImage)
            } else if let ciImage = image.ciImage {
                self.init(ciImage: ciImage)
            } else {
                fatalError("Impossible: no CGImage *nor* CIImage found")
            }
        } else {
            assertionFailure("No UIImage was generated")
            self.init()
        }
    }
}

// TODO: check if SVG still blurry without resize in iOS 15.
extension UIImage {
    public func resized(width: CGFloat, height: CGFloat) -> UIImage {
        resized(width: Optional(width), height: Optional(height))
    }

    public func resized(width: CGFloat) -> UIImage {
        resized(width: width, height: nil)
    }

    public func resized(height: CGFloat) -> UIImage {
        resized(width: nil, height: height)
    }

    private func resized(width: CGFloat?, height: CGFloat?) -> UIImage {
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
