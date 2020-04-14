import SwiftUI

protocol PickableOption: CaseIterable, RawRepresentable, Hashable where AllCases: RandomAccessCollection, RawValue: Hashable {
    var title: String { get }
}

struct FloatingPicker<Selection: PickableOption>: View {
    var selection: Binding<Selection>
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
            Picker("", selection: selection) {
                ForEach(Selection.allCases, id: \.rawValue) {
                    Text($0.title).tag($0)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
        }
        .background(Color.systemLightGray.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edge: .bottom))
        .onAppear(perform: UIApplication.shared.dismissKeyboard)
    }
}
