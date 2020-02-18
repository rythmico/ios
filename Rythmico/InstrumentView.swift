import SwiftUI

struct InstrumentViewData {
    var name: String
    var icon: Image
}

struct InstrumentView: View {
    private let viewData: InstrumentViewData

    init(viewData: InstrumentViewData) {
        self.viewData = viewData
    }

    var body: some View {
        HStack {
            Text(viewData.name)
                .rythmicoFont(.headline)
                .foregroundColor(.black)
                .padding(.leading, 22)
            Spacer()
            viewData.icon.padding(.trailing, 8)
        }
        .padding(.vertical, 8)
        .modifier(RoundedShadowContainer())
    }
}

struct InstrumentView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            InstrumentView(viewData: .init(name: "Piano", icon: Image(decorative: "instrument-icon-guitar")))
            InstrumentView(viewData: .init(name: "Piano", icon: Image(decorative: "instrument-icon-guitar")))
            InstrumentView(viewData: .init(name: "Piano", icon: Image(decorative: "instrument-icon-guitar")))
            InstrumentView(viewData: .init(name: "Piano", icon: Image(decorative: "instrument-icon-guitar")))
        }.padding(.horizontal, 20)
    }
}
