import SwiftUI

struct AvatarView: View {
    enum Content {
        case initials(String)
        case photo(Image)
        case placeholder

        var initials: String? {
            guard case .initials(let initials) = self else { return nil }
            return initials
        }

        var photo: Image? {
            guard case .photo(let image) = self else { return nil }
            return image
        }

        var isPlaceholder: Bool {
            guard case .placeholder = self else { return false }
            return true
        }
    }

    var content: Content
    var size: CGFloat = .spacingUnit * 9
    var backgroundColor: Color = .rythmicoGray10

    var body: some View {
        contentView
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
    }

    private var contentView: AnyView {
        initialsView ?? photoView ?? placeholderView
    }

    private var initialsView: AnyView? {
        content.initials.map { initials in
            AnyView(
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
    }

    private var photoView: AnyView? {
        content.photo.map { image in
            AnyView(
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
        }
    }

    private var placeholderView: AnyView {
        AnyView(
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
