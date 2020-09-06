import SwiftUI

extension View {
    func runCoordinator<Request: AuthorizedAPIRequest, VV: VisibleView>(
        _ coordinator: APIActivityCoordinator<Request>,
        on view: VV
    ) -> some View where Request.Properties == Void {
        self.onAppear(perform: coordinator.start)
            .onEvent(.appInBackground, perform: coordinator.reset)
            .onEvent(.appInForeground, if: view.isVisibleBinding, perform: coordinator.start)
    }
}
