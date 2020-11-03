import UIKit

protocol URLOpener {
    func open(_ url: URL)
    func canOpenURL(_ url: URL) -> Bool
}

extension URLOpener {
    func open(_ urlString: String) {
        open(URL(string: urlString)!)
    }

    func canOpenURL(_ urlString: String) -> Bool {
        canOpenURL(URL(string: urlString)!)
    }
}

extension UIApplication: URLOpener {
    func open(_ url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}
