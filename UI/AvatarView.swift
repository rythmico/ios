import SwiftUI

struct AvatarView: View {
    enum Const {
        static let defaultSize: CGFloat = .spacingUnit * 9
    }

    enum Content {
        case initials(String)
        case photo(Image)
        case placeholder
    }

    var content: Content
    var size: CGFloat = Const.defaultSize
    var backgroundColor: Color = .rythmicoGray10

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
            }
        )
    }
}

#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarView(content: .initials("DR"))
            AvatarView(content: .photo(Image(decorative: "avatar")))
            AvatarView(content: .placeholder)

            AvatarView(content: .initials("DR"), size: 200)
            AvatarView(content: .photo(Image(decorative: "avatar")), size: 200)
            AvatarView(content: .placeholder, size: 200)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
