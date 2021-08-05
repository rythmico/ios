import SwiftUISugar

struct CloseButton: View {
    let action: Action

    var body: some View {
        Button(action: action) {
            Image.x.padding(.horizontal, .grid(7)).offset(x: .grid(7))
        }
        .accessibility(label: Text("Close"))
    }
}
