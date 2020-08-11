import SwiftUI
import Sugar

extension View {
    func mapOpeningSheet(
        isPresented: Binding<Bool>,
        mapOpener: MapOpenerProtocol = Current.mapOpener,
        action: MapLink.Action,
        error: Binding<Error?>
    ) -> some View {
        actionSheet(isPresented: isPresented) {
            ActionSheet(
                title: Text("Open in..."),
                message: nil,
                buttons: [
                    .default(Text("Apple Maps"), action: errorBindingAction(for: { try mapOpener.open(.appleMaps(action)) }, through: error)),
                    .default(Text("Google Maps"), action: errorBindingAction(for: { try mapOpener.open(.googleMaps(action, zoom: 10)) }, through: error)),
                    .cancel()
                ]
            )
        }
        .alert(error: error)
    }

    private func errorBindingAction(for action: @escaping () throws -> Void, through errorBinding: Binding<Error?>) -> (() -> Void) {
        {
            errorBinding.wrappedValue = Result(catching: action).failureValue
        }
    }
}
