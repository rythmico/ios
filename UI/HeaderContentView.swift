import SwiftUI

struct HeaderContentView<TitleAccessory: View, Content: View>: View {
    var title: Text
    @ViewBuilder
    var titleAccessory: TitleAccessory
    @ViewBuilder
    var content: Content

    init(title: Text, @ViewBuilder titleAccessory: () -> TitleAccessory, @ViewBuilder content: () -> Content) {
        self.title = title
        self.titleAccessory = titleAccessory()
        self.content = content()
    }

    init(title: String, @ViewBuilder titleAccessory: () -> TitleAccessory, @ViewBuilder content: () -> Content) {
        self.init(title: Text(title), titleAccessory: titleAccessory, content: content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .grid(3)) {
            HStack(alignment: .center, spacing: .grid(2)) {
                title.foregroundColor(.rythmicoForeground).rythmicoTextStyle(.bodyBold)
                titleAccessory
            }
            content
        }
    }
}

extension HeaderContentView where TitleAccessory == EmptyView {
    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: Text(title), titleAccessory: { EmptyView() }, content: content)
    }

    init(title: Text, @ViewBuilder content: () -> Content) {
        self.init(title: title, titleAccessory: { EmptyView() }, content: content)
    }
}
