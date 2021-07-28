import SwiftUISugar

struct ProfileCell<Accessory: View>: View {
    var title: String
    var disclosure: Bool
    var action: Action?
    var accessory: Accessory

    init(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.disclosure = disclosure
        self.action = action
        self.accessory = accessory()
    }

    var body: some View {
        container
            .foregroundColor(.rythmico.gray90)
            .padding(.horizontal, .grid(5) - UITableViewCell.defaultHorizontalPadding)
            .padding(.vertical, .grid(2))
            .frame(minHeight: 51)
    }

    @ViewBuilder
    private var container: some View {
        if let action = action {
            Button(action: action) { content }
        } else {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        HStack {
            Text(title)
                .rythmicoTextStyle(.body)
                .frame(maxWidth: .infinity, alignment: .leading)

            accessory

            if disclosure {
                Image(decorative: Asset.Icon.Misc.disclosure.name).renderingMode(.template)
            }
        }
    }
}

extension ProfileCell where Accessory == EmptyView {
    init(
        _ title: String,
        disclosure: Bool = false,
        action: Action? = nil
    ) {
        self.title = title
        self.disclosure = disclosure
        self.action = action
        self.accessory = EmptyView()
    }
}
