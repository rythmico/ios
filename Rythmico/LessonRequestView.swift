import SwiftUI

struct LessonRequestView: View, Identifiable {
    private enum Const {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 28
    }

    let id = UUID()

    @Environment(\.betterSheetPresentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                List(0..<20, id: \.self) {
                    Text("Cell \($0)")
                }
            }
            .navigationBarTitle("Choose Instrument", displayMode: .large)
            .navigationBarItems(
                trailing: Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemSymbol: .xmark).font(.system(size: 21, weight: .semibold))
                        .padding(.vertical, Const.verticalPadding)
                        .padding(.horizontal, Const.horizontalPadding)
                        .offset(x: Const.horizontalPadding)
                }
                .accentColor(.rythmicoGray90)
                .accessibility(label: Text("Close lesson request screen"))
                .accessibility(hint: Text("Double tap to return to main screen"))
            )
        }
    }
}

protocol FormStep {
    var isCompleted: Bool { get set }
    var isCancellable: Bool { get }
}
