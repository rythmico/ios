import SwiftUIEncore

struct ProfileCell<Accessory: View>: View {
    @Environment(\.idealHorizontalInsets) private var idealHorizontalInsets

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
            .foregroundColor(.rythmico.foreground)
            .padding(.leading, idealHorizontalInsets.leading - UITableViewCell.defaultHorizontalPadding)
            .padding(.trailing, idealHorizontalInsets.trailing - UITableViewCell.defaultHorizontalPadding)
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
        HStack(spacing: .grid(3)) {
            Text(title)
                .rythmicoTextStyle(.body)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            accessory

            if disclosure { Image.chevronRight }
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
