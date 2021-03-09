import SwiftUI

struct HeaderContentView<TitleAccessory: View, Content: View>: View {
    var title: [MultiStyleText.Part]
    @ViewBuilder
    var titleAccessory: TitleAccessory
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
            HStack(alignment: .center, spacing: .spacingUnit * 2) {
                MultiStyleText(parts: title).fixedSize()
                titleAccessory
            }
            content
        }
    }
}

extension HeaderContentView where TitleAccessory == EmptyView {
    init(title: String, @ViewBuilder content: () -> Content) {
        self.init(title: [title.style(.bodyBold)], titleAccessory: { EmptyView() }, content: content)
    }

    init(title: [MultiStyleText.Part], @ViewBuilder content: () -> Content) {
        self.init(title: title, titleAccessory: { EmptyView() }, content: content)
    }
}
