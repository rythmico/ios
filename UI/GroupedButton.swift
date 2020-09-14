import SwiftUI

struct GroupedButton<Accessory: View>: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    var title: String
    var action: () -> Void
    var accessory: Accessory

    init(
        _ title: String,
        action: @escaping () -> Void,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.action = action
        self.accessory = accessory()
    }

    var body: some View {
        ZStack {
            Button(title, action: action)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer()
                accessory.transition(AnyTransition.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: .durationShort), value: isEnabled)
    }
}

#if DEBUG
struct GroupedButton_Previews: PreviewProvider {
    static var previews: some View {
        List {
            GroupedButton("Something", action: {}) {
                ActivityIndicator()
            }
            .accentColor(.red)
            .disabled(true)
        }
        .listStyle(GroupedListStyle())
    }
}
#endif
