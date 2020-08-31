import SwiftUI

struct AvatarStackView: View {
    private enum Const {
        static let borderLineWidth: CGFloat = 2
        static let borderOutlineSize: CGFloat = AvatarView.Const.defaultSize + Const.borderLineWidth
        static let spacing: CGFloat = -AvatarView.Const.defaultSize * 0.42
    }

    var content: [AvatarView.Content]

    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<self.content.count) { index in
                AvatarView(content: self.content[index])
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
struct AvatarStackView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarStackView(
            content: [
                .photo(Image(decorative: "avatar")),
                .photo(Image(decorative: "avatar")),
                .photo(Image(decorative: "avatar")),
            ]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
