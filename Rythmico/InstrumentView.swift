import SwiftUI
import Sugar

struct InstrumentViewData {
    var name: String
    var icon: Image
    var action: Action
}

struct InstrumentView: View {
    private let viewData: InstrumentViewData

    init(viewData: InstrumentViewData) {
        self.viewData = viewData
    }

    var body: some View {
        Button(action: viewData.action) {
            HStack {
                Text(viewData.name)
                    .rythmicoFont(.headline)
                    .foregroundColor(.black)
                    .padding(.leading, .spacingMedium)
                    .padding(.vertical, .spacingMedium)
                Spacer()
                viewData.icon.renderingMode(.original).padding(.trailing, .spacingMedium)
            }
        }
        .modifier(RoundedShadowContainer())
    }
}

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
