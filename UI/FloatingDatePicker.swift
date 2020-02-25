import SwiftUI

struct FloatingDatePicker: View {
    var viewData: DatePickerViewData
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
            DatePicker(viewData).labelsHidden()
        }
        .background(Color.systemLightGray.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edge: .bottom))
        .onAppear(perform: UIApplication.shared.endEditing)
    }
}
