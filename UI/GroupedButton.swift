import SwiftUIEncore

struct GroupedButton<Accessory: View>: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var title: String
    var action: () -> Void
    @ViewBuilder
    var accessory: Accessory

    var body: some View {
        ZStack {
            Button(title, action: action)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer()
                accessory.transition(.opacity + .scale)
            }
        }
        .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }
}

extension GroupedButton where Accessory == EmptyView {
    init(title: String, action: @escaping () -> Void) {
        self.init(title: title, action: action) { EmptyView() }
    }
}

#if DEBUG
struct GroupedButton_Previews: PreviewProvider {
    static var previews: some View {
        List {
            GroupedButton(title: "Something", action: {}) {
                ActivityIndicator()
            }
            .accentColor(.red)
            .disabled(true)
        }
        .listStyle(GroupedListStyle())
    }
}
#endif
