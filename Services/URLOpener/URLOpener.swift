import SwiftUISugar

protocol URLOpener {
    func open(_ url: URL)
    func canOpenURL(_ url: URL) -> Bool
}

extension URLOpener {
    func open(_ urlString: String) {
        open(url(with: urlString))
    }

    func canOpenURL(_ urlString: String) -> Bool {
        canOpenURL(url(with: urlString))
    }

    private func url(with urlString: String) -> URL {
        URL(string: urlString) !! preconditionFailure("Invalid terms and conditions URL with string: '\(urlString)'")
    }
}

extension UIApplication: URLOpener {
    func open(_ url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}
