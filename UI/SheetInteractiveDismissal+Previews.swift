import SwiftUI

#if DEBUG
struct AdaptivePresentationView_Previews: PreviewProvider {
    struct Preview: View {
        @State var isPresenting = false
        @State var isDismissable = false

        var body: some View {
            Button("Present") { self.isPresenting.toggle() }
                .sheet(isPresented: $isPresenting) {
                    HStack {
                        Text("Dismissable")
                        Toggle("", isOn: self.$isDismissable).labelsHidden()
                    }
                    .sheetInteractiveDismissal(self.isDismissable)
                }
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif

