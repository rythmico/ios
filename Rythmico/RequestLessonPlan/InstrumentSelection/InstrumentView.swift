import SwiftUI
import Sugar

struct InstrumentViewData {
    var name: String
    var icon: Image
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
                Spacer()
                viewData.icon.renderingMode(.template)
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
            InstrumentView(viewData: .init(name: "Guitar", icon: Image(decorative: Asset.instrumentIconGuitar.name), action: {}))
            InstrumentView(viewData: .init(name: "Drums", icon: Image(decorative: Asset.instrumentIconDrums.name), action: {}))
            InstrumentView(viewData: .init(name: "Piano", icon: Image(decorative: Asset.instrumentIconPiano.name), action: {}))
            InstrumentView(viewData: .init(name: "Singing", icon: Image(decorative: Asset.instrumentIconSinging.name), action: {}))
        }.padding(.horizontal, 20)
    }
}
#endif
