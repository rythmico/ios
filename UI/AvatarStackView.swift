import SwiftUI

struct AvatarStackView: View {
    private enum Const {
        static let borderLineWidth: CGFloat = 2
        static let borderOutlineSize: CGFloat = AvatarView.Const.defaultSize + Const.borderLineWidth
        static let spacing: CGFloat = -AvatarView.Const.defaultSize * 0.42
    }

    var contents: [AvatarView.Content]

    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<contents.count, id: \.self) { index in
                AvatarView(content: self.contents[index])
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: Const.borderLineWidth)
                            .frame(width: Const.borderOutlineSize, height: Const.borderOutlineSize)
                    )
                    .zIndex(Double(-index))
            }
        }
    }
}

#if DEBUG
struct AvatarStackView_PreviewsWrapper: View {
    @State var content: [AvatarView.Content] = [
        .initials("DR"),
        .photo(Image(decorative: "avatar")),
        .initials("DR"),
    ]

    var body: some View {
        AvatarStackView(contents: content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.content = [
                        .photo(Image(decorative: "avatar")),
                        .photo(Image(decorative: "avatar")),
                        .photo(Image(decorative: "avatar")),
                    ]
                }
            }
    }
}

struct AvatarStackView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarStackView_PreviewsWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
