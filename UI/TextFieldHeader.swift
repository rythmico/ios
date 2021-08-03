import SwiftUI

struct TextFieldHeader<Accessory: View, Content: View>: View {
    var title: Text
    @ViewBuilder
    var accessory: Accessory
    @ViewBuilder
    var content: Content

    init(_ title: Text, @ViewBuilder accessory: () -> Accessory, @ViewBuilder content: () -> Content) {
        self.title = title
        self.accessory = accessory()
        self.content = content()
    }

    init(_ title: String, @ViewBuilder accessory: () -> Accessory, @ViewBuilder content: () -> Content) {
        self.init(Text(title), accessory: accessory, content: content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(2)) {
            HStack(alignment: .center, spacing: .grid(2)) {
                title.foregroundColor(.rythmico.foreground).rythmicoTextStyle(.bodyBold)
                accessory
            }
            content
        }
    }
}

extension TextFieldHeader where Accessory == EmptyView {
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.init(Text(title), accessory: { EmptyView() }, content: content)
    }

    init(_ title: Text, @ViewBuilder content: () -> Content) {
        self.init(title, accessory: { EmptyView() }, content: content)
    }
}
