import SwiftUI

struct AvatarView: View {
    enum Const {
        static let defaultSize: CGFloat = .spacingUnit * 8
        static let defaultBackgroundColor: Color = .rythmicoGray10
    }

    enum Content {
        case initials(String)
        case photo(Image)
        case placeholder
    }

    private let content: Content
    private let size: CGFloat
    private let backgroundColor: Color

    init(
        _ content: Content,
        size: CGFloat = Const.defaultSize,
        backgroundColor: Color = Const.defaultBackgroundColor
    ) {
        self.content = content
        self.size = size
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        contentView
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: .durationShort)))
    }

    // TODO: switch views
    private var contentView: AnyView? {
        initialsView ?? photoView ?? placeholderView
    }

    private var initialsView: AnyView? {
        guard case .initials(let initials) = content else {
            return nil
        }
        return AnyView(
            GeometryReader { g in
                Text(initials)
                    .font(.system(size: max(g.size.width, g.size.height), weight: .medium, design: .rounded))
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                    .lineLimit(1)
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, g.size.width * 0.18)
                    .centerV()
            }
        )
    }

    private var photoView: AnyView? {
        guard case .photo(let image) = content else {
            return nil
        }
        return AnyView(
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }

    private var placeholderView: AnyView? {
        guard case .placeholder = content else {
            return nil
        }
        return AnyView(
            GeometryReader { g in
                Image(systemSymbol: .person)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: g.size.width, weight: .medium, design: .rounded))
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, g.size.width * 0.255)
                    .offset(x: 0, y: -g.size.height * 0.02)
                    .centerV()
            }
        )
    }
}

#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarView(.initials("DR"))
            AvatarView(.photo(Image(decorative: "avatar")))
            AvatarView(.placeholder)

            AvatarView(.initials("DR"), size: 200)
            AvatarView(.photo(Image(decorative: "avatar")), size: 200)
            AvatarView(.placeholder, size: 200)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
