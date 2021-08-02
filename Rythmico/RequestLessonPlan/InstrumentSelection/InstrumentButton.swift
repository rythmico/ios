import SwiftUISugar

struct InstrumentButton: View {
    @Environment(\.colorScheme) private var colorScheme

    var instrument: Instrument
    var action: Action

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth: CGFloat = .grid(12)

    var body: some View {
        AdHocButton(action: action) { state in
            SelectableContainer(isSelected: state == .pressed) { _ in
                VStack(spacing: .grid(3)) {
                    Image(uiImage: instrument.icon.image.resized(width: iconWidth))
                        .renderingMode(.template)
                    Text(instrument.standaloneName)
                        .rythmicoTextStyle(.subheadlineBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding(.top, .grid(5))
                .padding([.horizontal, .bottom], .grid(4))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#if DEBUG
struct InstrumentButton_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(Instrument.allCases, id: \.self) {
            InstrumentButton(instrument: $0, action: {})
        }
        .frame(width: 150, height: 150)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
