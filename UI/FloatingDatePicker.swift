import SwiftUI

struct FloatingDatePicker: View {
    var selection: Binding<Date>
    var doneButtonAction: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: doneButtonAction) {
                    Text("Done").rythmicoFont(.callout).foregroundColor(.rythmicoPurple)
                }
                .padding(.horizontal, .spacingMedium)
                .padding(.top, .spacingExtraSmall)
            }
            DatePicker(
                "",
                selection: self.selection,
                displayedComponents: .date
            ).labelsHidden()
        }
        .background(Color.systemLightGray.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edge: .bottom))
        .onAppear(perform: UIApplication.shared.endEditing)
    }
}
