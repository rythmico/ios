import SwiftUI

struct AvatarView: View {
    enum Const {
        static let defaultSize: CGFloat = .spacingUnit * 8
        static let defaultBackgroundColor: Color = .rythmicoGray10
    }

    enum Content {
        case initials(String)
        case photo(UIImage)
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

    @ViewBuilder
    private var contentView: some View {
        switch content {
        case .initials(let initials):
            GeometryReader { g in
                Text(initials)
                    .font(.system(size: g.size.width, weight: .medium, design: .rounded))
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                    .lineLimit(1)
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, g.size.width * 0.18)
                    .position(x: g.size.width / 2, y: g.size.height / 2)
            }
        case .photo(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        case .placeholder:
            GeometryReader { g in
                Image(systemSymbol: .person)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: g.size.width, weight: .medium, design: .rounded))
                    .minimumScaleFactor(.leastNonzeroMagnitude)
                    .foregroundColor(.rythmicoGray90)
                    .padding(.horizontal, g.size.width * 0.255)
                    .offset(x: 0, y: -g.size.height * 0.02)
                    .position(x: g.size.width / 2, y: g.size.height / 2)
            }
        }
    }
}

#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarView(.initials("DR"))
            AvatarView(.photo(UIImage(.red)))
            AvatarView(.placeholder)

            AvatarView(.initials("DR"), size: 200)
            AvatarView(.photo(UIImage(.purple)), size: 200)
            AvatarView(.placeholder, size: 200)
        }
        .environment(\.colorScheme, .dark)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
