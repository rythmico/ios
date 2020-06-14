import SwiftUI

extension CGFloat {
    static let spacingUnit: CGFloat = 4
    static let spacingExtraSmall: CGFloat = spacingUnit * 3
    static let spacingSmall: CGFloat = spacingUnit * 4
    static let spacingMedium: CGFloat = spacingUnit * 5
    static let spacingLarge: CGFloat = spacingUnit * 6
    static let spacingExtraLarge: CGFloat = spacingUnit * 7
}

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
