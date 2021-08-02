import SwiftUI

private enum Const {
    static let spacing: CGFloat = -AvatarView.Const.minSize * 0.42
}

struct AvatarStackView<Data: RangeReplaceableCollection, ContentView: View>: View where Data.Index == Int {
    var data: Data
    @ViewBuilder
    var content: (Data.Element) -> ContentView

    var body: some View {
        HStack(spacing: Const.spacing) {
            ForEach(0..<data.count, id: \.self) { index in
                content(data[index])
                    .frame(width: AvatarView.Const.minSize, height: AvatarView.Const.minSize)
                    .background(
                        Circle()
                            .inset(by: -2)
                            .fill(Color.rythmico.background)
                    )
                    .zIndex(Double(-index))
            }
        }
    }
}

extension AvatarStackView where Data.Element == AvatarView.Content, ContentView == AvatarView {
    init(_ data: Data) {
        self.init(data: data) { AvatarView($0) }
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
        AvatarStackView(content)
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
