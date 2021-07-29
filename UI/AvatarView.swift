import SwiftUI

struct AvatarView: View {
    enum Const {
        static let minSize: CGFloat = .grid(8)
        static let defaultBackgroundColor: Color = .rythmico.gray10
    }

    enum Content {
        case initials(String)
        case photo(UIImage)
        case placeholder
    }

    private let content: Content
    private let backgroundColor: Color

    init(_ content: Content, backgroundColor: Color = Const.defaultBackgroundColor) {
        self.content = content
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        GeometryReader { g in
            contentView
                .frame(width: g.size.width, height: g.size.height)
                .background(backgroundColor)
                .clipShape(Circle())
        }
        .frame(minWidth: Const.minSize, minHeight: Const.minSize)
        .scaledToFit()
    }

    @ViewBuilder
    private var contentView: some View {
        switch content {
        case .initials(let initials):
            GeometryReader { g in
                Text(initials)
                    .font(.system(size: g.size.width / 2, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .foregroundColor(.rythmico.gray90)
                    .position(x: g.frame(in: .local).midX, y: g.frame(in: .local).midY)
            }
            .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
        case .photo(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
        case .placeholder:
            GeometryReader { g in
                Image(systemSymbol: .person)
                    .font(.system(size: g.size.width / 1.75, weight: .medium, design: .rounded))
                    .offset(y: -g.size.height * 0.025)
                    .foregroundColor(.rythmico.gray90)
                    .position(x: g.frame(in: .local).midX, y: g.frame(in: .local).midY)
            }
            .transition(.opacity.animation(.easeInOut(duration: .durationShort)))
        }
    }
}

#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Group {
                AvatarView(.initials("DR")).fixedSize()
                AvatarView(.initials("DR")).frame(width: 100, height: 100)
                AvatarView(.initials("DR")).frame(width: 300, height: 300)
                AvatarView(.initials("DR")).frame(width: 600, height: 600)
            }

            Group {
                AvatarView(.photo(UIImage(solidColor: .red))).fixedSize()
                AvatarView(.photo(UIImage(solidColor: .purple))).frame(width: 100, height: 100)
                AvatarView(.photo(UIImage(solidColor: .purple))).frame(width: 300, height: 300)
                AvatarView(.photo(UIImage(solidColor: .purple))).frame(width: 600, height: 600)
            }

            Group {
                AvatarView(.placeholder).fixedSize()
                AvatarView(.placeholder).frame(width: 100, height: 100)
                AvatarView(.placeholder).frame(width: 300, height: 300)
                AvatarView(.placeholder).frame(width: 600, height: 600)
            }
        }
        .environment(\.colorScheme, .dark)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
