import SwiftUISugar

struct InstrumentView: View {
    let instrument: Instrument

    var body: some View {
        Container(style: .outline(fill: .rythmico.background)) {
            ZStack {
                Text(instrument.standaloneName)
                    .rythmicoTextStyle(.subheadlineBold)
                    .padding([.vertical, .leading], .grid(5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.rythmico.foreground)
            }
            .watermark(
                instrument.icon.image,
                width: 125,
                offset: .init(width: 15, height: -8),
                color: .rythmico.picoteeBlue
            )
        }
        .frame(minHeight: 70)
        .accessibility(hint: Text("Double tap to select this instrument"))
    }
}

#if DEBUG
struct InstrumentView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(Instrument.allCases, id: \.self, content: InstrumentView.init)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif

