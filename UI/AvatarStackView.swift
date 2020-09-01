import SwiftUI

private enum Const {
    static let borderLineWidth: CGFloat = 2
    static let borderOutlineSize: CGFloat = AvatarView.Const.defaultSize + borderLineWidth
    static let spacing: CGFloat = -AvatarView.Const.defaultSize * 0.42
}

struct AvatarStackView<Data: RangeReplaceableCollection, ContentView: View>: View where Data.Index == Int {
    private let data: Data
    private let content: (Data.Element) -> ContentView

    init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> ContentView) {
        self.data = data
        self.content = content
    }

    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<data.count, id: \.self) { index in
                self.content(self.data[index])
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

extension AvatarStackView where Data.Element == AvatarView.Content, ContentView == AvatarView {
    init(_ data: Data) {
        self.init(data) { AvatarView($0) }
    }
}

#if DEBUG
struct AvatarStackView_PreviewsWrapper: View {
    @State var content: [AvatarView.Content] = [
        .initials("DR"),
        .photo(Asset.appLogo.image),
        .initials("DR"),
    ]

    var body: some View {
        AvatarStackView(content)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.content = [
                        .photo(Asset.appLogo.image),
                        .photo(Asset.appLogo.image),
                        .photo(Asset.appLogo.image),
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
