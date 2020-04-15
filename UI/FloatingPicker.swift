import SwiftUI

// TODO: generalize components
// - Implement FloatingView<Content: View> (white background)
// - Implement FloatingViewContainer<Content: View> and helper View.floatingViewContainer function.
// - Implement FloatingInputView<Content: View> (gray background)
// - FloatingButton -> FloatingView<Button> (make button styling a modifier)
// - FloatingDatePickerPicker -> FloatingInputView<DatePicker>
// - FloatingPicker -> FloatingInputView<BetterPicker> (extract FloatingPicker's picker into BetterPicker with existing generics)
struct FloatingPicker<Options: RandomAccessCollection, Selection: Hashable>: View where Options.Element == Selection {
    var options: Options
    var selection: Binding<Selection>
    var formatter: (Selection) -> String
    var doneButtonAction: () -> Void

    init(
        options: Options,
        selection: Binding<Selection>,
        formatter: @escaping (Selection) -> String,
        doneButtonAction: @escaping () -> Void
    ) {
        self.options = options
        self.selection = selection
        self.formatter = formatter
        self.doneButtonAction = doneButtonAction
    }

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
                ForEach(options, id: \.hashValue) {
                    Text(self.formatter($0)).tag($0)
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

extension FloatingPicker where Selection: CaseIterable, Selection.AllCases == Options {
    init(
        selection: Binding<Selection>,
        formatter: @escaping (Selection) -> String,
        doneButtonAction: @escaping () -> Void
    ) {
        self.init(
            options: Selection.allCases,
            selection: selection,
            formatter: formatter,
            doneButtonAction: doneButtonAction
        )
    }
}
