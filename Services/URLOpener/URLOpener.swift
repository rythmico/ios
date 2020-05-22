import UIKit

protocol URLOpener {
    func open(_ url: URL)
}

extension URLOpener {
    func open(_ urlString: String) {
        open(URL(string: urlString)!)
    }
}

extension UIApplication: URLOpener {
    func open(_ url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}
