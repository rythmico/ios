public struct HorizontalInsets: Equatable {
    public var leading: CGFloat
    public var trailing: CGFloat

    public init(leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.leading = leading
        self.trailing = trailing
    }

    public init(_ horizontal: CGFloat) {
        self.init(leading: horizontal, trailing: horizontal)
    }

    public static var zero: HorizontalInsets { .init() }
}

public struct VerticalInsets: Equatable {
    public var top: CGFloat
    public var bottom: CGFloat

    public init(top: CGFloat = 0, bottom: CGFloat = 0) {
        self.top = top
        self.bottom = bottom
    }

    public init(_ vertical: CGFloat) {
        self.init(top: vertical, bottom: vertical)
    }

    public static var zero: VerticalInsets { .init() }
}

extension EdgeInsets {
    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.init()
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(
            top: vertical,
            leading: horizontal,
            bottom: vertical,
            trailing: horizontal
        )
    }

    public init(horizontal: HorizontalInsets = .zero, vertical: VerticalInsets = .zero) {
        self.init(
            top: vertical.top,
            leading: horizontal.leading,
            bottom: vertical.bottom,
            trailing: horizontal.trailing
        )
    }

    public init(_ all: CGFloat) {
        self.init(
            top: all,
            leading: all,
            bottom: all,
            trailing: all
        )
    }

    public static var zero: EdgeInsets { .init() }
}
