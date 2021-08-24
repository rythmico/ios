import SwiftUIEncore

struct InstrumentSelectionItemView: View {
    let instrument: Instrument

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth: CGFloat = .grid(12)

    var body: some View {
        VStack(spacing: .grid(3)) {
            Image(uiImage: instrument.icon.image.resized(width: iconWidth))
                .renderingMode(.template)
            Text(instrument.standaloneName)
                .rythmicoTextStyle(.subheadlineBold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

#if DEBUG
struct InstrumentSelectionItemView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(
            Instrument.allCases,
            id: \.self,
            content: InstrumentSelectionItemView.init
        )
        .frame(width: 150, height: 150)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
