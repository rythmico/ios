import SwiftUI

struct BookingsTabView: View {
    var body: some View {
        BookingsView()
    }
}

#if DEBUG
struct BookingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        BookingsTabView()
    }
}
#endif
