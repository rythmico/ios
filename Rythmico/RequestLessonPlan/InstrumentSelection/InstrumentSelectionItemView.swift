import CoreDTO
import SwiftUIEncore

struct InstrumentSelectionItemView: View {
    let instrument: Instrument

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconSize: CGFloat = .grid(12)

    var body: some View {
        VStack(spacing: .grid(3)) {
            Image(uiImage: instrument.icon.resized(height: iconSize))
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
        ForEach([Instrument].stub, content: InstrumentSelectionItemView.init)
            .frame(width: 150, height: 150)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
