import SwiftUISugar

struct TwoSidedText: View {
    enum Anchor {
        case left
        case right
    }

    let left: String
    let right: String
    let style: Font.RythmicoTextStyle
    let anchor: Anchor?

    init(_ left: String, _ right: String, style: Font.RythmicoTextStyle, anchor: Anchor?) {
        self.left = left
        self.right = right
        self.style = style
        self.anchor = anchor
    }

    @State
    private var fullSize: CGSize?
    @State
    private var leftSize: CGSize?
    @State
    private var rightSize: CGSize?

    var body: some View {
        ZStack {
            Group {
                rawFullText.onSizeChange { fullSize = $0 }
                rawLeftText.onSizeChange { leftSize = $0 }
                rawRightText.onSizeChange { rightSize = $0 }
            }
            .hidden()

            HStack(spacing: 0) {
                if anchor == .none || anchor == .left {
                    leftText
                }
                if anchor == .none || anchor == .right {
                    rightText
                }
            }
            .frame(
                width: anchor == nil ? fullSize?.width : nil,
                height: anchor == nil ? fullSize?.height : nil
            )
        }
        .lineLimit(1)
        .animation(.rythmicoSpring(duration: .durationShort))
    }

    private var rawFullText: some View {
        Text(left + right).rythmicoTextStyle(style)
    }

    private var rawLeftText: some View {
        Text(left).rythmicoTextStyle(style)
    }

    private var rawRightText: some View {
        Text(right).rythmicoTextStyle(style)
    }

    private var leftText: some View {
        struct Id: Hashable {}
        return rawLeftText
            .id(Id())
            .multilineTextAlignment(anchor == .left ? .center : .leading)
            .transition(.offset(x: leftTextXOffset) + .opacity)
    }

    private var leftTextXOffset: CGFloat {
        (rightSize?.width ?? 0) / 2
    }

    private var rightText: some View {
        struct Id: Hashable {}
        return rawRightText
            .id(Id())
            .multilineTextAlignment(anchor == .right ? .center : .trailing)
            .transition(.offset(x: rightTextXOffset) + .opacity)
    }

    private var rightTextXOffset: CGFloat {
        -(leftSize?.width ?? 0) / 2
    }
}

#if DEBUG
struct TwoSidedText_Previews: PreviewProvider {
    static let left = "Welcome to "
    static let right = "Rythmico"
    static let fixedAnchor: TwoSidedText.Anchor = .right

    @ViewBuilder
    static var previews: some View {
        StatefulView(Optional(fixedAnchor)) { anchor in
            VStack(spacing: 0) {
                Text(left + right)
                    .rythmicoTextStyle(.headline)
                    .backgroundColor(.red)
                    .lineLimit(1)
                TwoSidedText(left, right, style: .headline, anchor: anchor.wrappedValue)
                    .backgroundColor(.red)
            }
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundColor(.clear)
            .onTapGesture {
                anchor.wrappedValue = anchor.wrappedValue == nil ? fixedAnchor : nil
            }
        }
//        .environment(\.sizeCategory, .extraExtraExtraLarge)
    }
}
#endif
