import SwiftUI

struct PageDotIndicator<Items: RandomAccessCollection>: View where Items.Element: Hashable {
    typealias Item = Items.Element

    @Binding
    var selection: Item
    var items: Items

    var foregroundColor = Color.white.opacity(0.5)
    var accentColor: Color = .white

    var body: some View {
        HStack(spacing: .spacingUnit * 2) {
            ForEach(items, id: \.self) { item in
                Dot(color: selection == item ? accentColor : foregroundColor)
            }
        }
    }
}

#if DEBUG
struct PageDotIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PageDotIndicator(selection: .constant(1), items: [1, 2, 3])
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
    }
}
#endif
