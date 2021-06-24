import SwiftUI

extension EdgeInsets {
    init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.init()
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init()
        self.top = vertical
        self.leading = horizontal
        self.bottom = vertical
        self.trailing = horizontal
    }

    init(_ all: CGFloat) {
        self.init()
        self.top = all
        self.leading = all
        self.bottom = all
        self.trailing = all
    }

    static var zero: EdgeInsets { .init() }
}
