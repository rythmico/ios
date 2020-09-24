import SwiftUI

struct DotPageIndicator<Item: Hashable>: View {
    @Binding
    var selection: Item
    var items: [Item]

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
struct DotPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        DotPageIndicator(selection: .constant(1), items: [1, 2, 3])
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.black)
    }
}
#endif
