import SwiftUIEncore

extension View {
    func mapOpeningSheet(
        isPresented: Binding<Bool>,
        urlOpener: URLOpener = Current.urlOpener,
        intent: MapLink.Intent,
        error: Binding<Error?>
    ) -> some View {
        let mapLinks: [MapLink] = [
            .appleMaps(intent),
            .googleMaps(intent, zoom: 10),
        ]

        func button(for link: MapLink) -> ActionSheet.Button {
            .default(Text(link.appName)) {
                error.wrappedValue = Result { try urlOpener.open(link) }.failureValue
            }
        }

        return actionSheet(isPresented: isPresented) {
            ActionSheet(title: Text("Open in..."), buttons: mapLinks.map(button) + .cancel())
        }
        .alert(error: error)
    }
}

private extension MapLink {
    var appName: String {
        switch self {
        case .appleMaps:
            return "Apple Maps"
        case .googleMaps:
            return "Google Maps"
        }
    }
}
