import SwiftUI

#if DEBUG
struct AdaptivePresentationView_Previews: PreviewProvider {
    struct Preview: View {
        @State var isPresenting = false
        @State var isDismissable = false
        @State var attempts = 0

        var body: some View {
            Button("Present") { self.isPresenting.toggle() }
                .sheet(isPresented: $isPresenting) {
                    HStack {
                        Text("Dismissable (attempted: \(self.attempts))")
                        Toggle("", isOn: self.$isDismissable).labelsHidden()
                    }
                    .sheetInteractiveDismissal(self.isDismissable, onAttempt: { self.attempts += 1 })
                }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
