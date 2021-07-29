import SwiftUISugar

struct InstrumentViewData {
    var name: String
    var icon: ImageAsset
    var action: Action?
}

struct InstrumentView: View {
    var viewData: InstrumentViewData

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth: CGFloat = .grid(12)

    var body: some View {
        Button(action: { viewData.action?() }) {
            HStack(spacing: .grid(2)) {
                Text(viewData.name)
                    .rythmicoTextStyle(.subheadlineBold)
                    .padding([.vertical, .leading], .grid(5))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(uiImage: viewData.icon.image.resized(width: iconWidth))
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconWidth, alignment: .center)
                    .padding(.vertical, .grid(3))
                    .padding(.trailing, .grid(4))
            }
            .foregroundColor(.rythmico.foreground)
        }
        .frame(minHeight: 70)
        .modifier(RoundedShadowContainer())
        .disabled(viewData.action == nil)
        .accessibility(hint: Text(viewData.action != nil ? "Double tap to select this instrument" : .empty))
    }
}

#if DEBUG
struct InstrumentView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            InstrumentView(viewData: .init(name: "Guitar", icon: Asset.Graphic.Instrument.guitar, action: {}))
            InstrumentView(viewData: .init(name: "Drums", icon: Asset.Graphic.Instrument.drums, action: {}))
            InstrumentView(viewData: .init(name: "Piano", icon: Asset.Graphic.Instrument.piano, action: {}))
            InstrumentView(viewData: .init(name: "Singing", icon: Asset.Graphic.Instrument.singing, action: {}))
            InstrumentView(viewData: .init(name: "Saxophone", icon: Asset.Graphic.Instrument.saxophone, action: {}))
            InstrumentView(viewData: .init(name: "Trumpet", icon: Asset.Graphic.Instrument.trumpet, action: {}))
            InstrumentView(viewData: .init(name: "Flute", icon: Asset.Graphic.Instrument.flute, action: {}))
            InstrumentView(viewData: .init(name: "Violin", icon: Asset.Graphic.Instrument.violin, action: {}))
        }.padding(.horizontal, 20)
    }
}
#endif
