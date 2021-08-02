import SwiftUI

private enum Const {
    static let spacing: CGFloat = -AvatarView.Const.minSize * 0.42
}

struct AvatarStackView<Data: RangeReplaceableCollection, ContentView: View>: View where Data.Index == Int {
    let data: Data
    let backgroundColor: Color
    @ViewBuilder
    let content: (Data.Element) -> ContentView

    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<data.count, id: \.self) { index in
                content(data[index])
                    .frame(width: AvatarView.Const.minSize, height: AvatarView.Const.minSize)
                    .background(
                        Circle()
                            .inset(by: -2)
                            .fill(backgroundColor)
                    )
                    .zIndex(Double(-index))
            }
        }
    }
}

extension AvatarStackView where Data.Element == AvatarView.Content, ContentView == AvatarView {
    init(_ data: Data, backgroundColor: Color) {
        self.init(data: data, backgroundColor: backgroundColor) { AvatarView($0) }
    }
}

#if DEBUG
struct AvatarStackView_PreviewsWrapper: View {
    @State var content: [AvatarView.Content] = [
        .initials("DR"),
        .photo(UIImage(solidColor: .purple)),
        .initials("DR"),
    ]

    var body: some View {
        AvatarStackView(content, backgroundColor: .rythmico.background)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    content = [
                        .photo(UIImage(solidColor: .red)),
                        .photo(UIImage(solidColor: .blue)),
                        .photo(UIImage(solidColor: .green)),
                    ]
                }
            }
    }
}

struct AvatarStackView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarStackView_PreviewsWrapper()
//            .environment(\.colorScheme, .dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
