import SwiftUI
import Sugar

struct InstrumentViewData {
    var name: String
    var icon: ImageAsset
    var action: Action?
}

struct InstrumentView: View {
    private let viewData: InstrumentViewData

    init(viewData: InstrumentViewData) {
        self.viewData = viewData
    }

    var body: some View {
        Button(action: { viewData.action?() }) {
            HStack {
                Text(viewData.name)
                    .rythmicoFont(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
                    .padding(.leading, .spacingMedium)
                    .padding(.vertical, .spacingMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VectorImage(asset: viewData.icon)
                    .accentColor(.rythmicoForeground)
                    .padding(.trailing, .spacingMedium)
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
        }.padding(.horizontal, 20)
    }
}
#endif
