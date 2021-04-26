import SwiftUI
import FoundationSugar

struct InstrumentViewData {
    var name: String
    var icon: ImageAsset
    var action: Action?
}

struct InstrumentView: View {
    private let viewData: InstrumentViewData

    @ScaledMetric(relativeTo: .largeTitle)
    private var iconWidth = .spacingUnit * 18

    init(viewData: InstrumentViewData) {
        self.viewData = viewData
    }

    var body: some View {
        Button(action: { viewData.action?() }) {
            HStack(spacing: .spacingUnit * 2) {
                Text(viewData.name)
                    .rythmicoTextStyle(.headline)
                    .foregroundColor(.rythmicoForeground)
                    .padding([.vertical, .leading], .spacingMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(decorative: viewData.icon.name)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconWidth, alignment: .center)
                    .padding(.vertical, .spacingUnit * 2)
                    .padding(.trailing, .spacingExtraSmall)
            }
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
            InstrumentView(viewData: .init(name: "Guitar", icon: Asset.instrumentIconGuitar, action: {}))
            InstrumentView(viewData: .init(name: "Drums", icon: Asset.instrumentIconDrums, action: {}))
            InstrumentView(viewData: .init(name: "Piano", icon: Asset.instrumentIconPiano, action: {}))
            InstrumentView(viewData: .init(name: "Singing", icon: Asset.instrumentIconSinging, action: {}))
            InstrumentView(viewData: .init(name: "Saxophone", icon: Asset.instrumentIconSaxophone, action: {}))
            InstrumentView(viewData: .init(name: "Trumpet", icon: Asset.instrumentIconTrumpet, action: {}))
            InstrumentView(viewData: .init(name: "Flute", icon: Asset.instrumentIconFlute, action: {}))
            InstrumentView(viewData: .init(name: "Violin", icon: Asset.instrumentIconViolin, action: {}))
        }.padding(.horizontal, 20)
    }
}
#endif
