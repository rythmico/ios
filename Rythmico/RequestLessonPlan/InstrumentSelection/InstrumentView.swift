import CoreDTO
import SwiftUIEncore

struct InstrumentView: View {
    let instrument: Instrument

    var body: some View {
        Container(style: .outline(fill: Color.rythmico.background)) {
            ZStack {
                Text(instrument.standaloneName)
                    .rythmicoTextStyle(.subheadlineBold)
                    .padding([.vertical, .leading], .grid(5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.rythmico.foreground)
            }
            .watermark(
                instrument.icon,
                color: .rythmico.picoteeBlue,
                width: 100,
                offset: .init(width: 5, height: -8)
            )
        }
        .frame(minHeight: 70)
        .accessibility(hint: Text("Double tap to select this instrument"))
    }
}

#if DEBUG
struct InstrumentView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach([Instrument].stub, content: InstrumentView.init)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif

