import SwiftUI

extension ScrollView where Content == ScrollViewReader<AnyView> {
    init<InnerContent: View>(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> InnerContent
    ) {
        self.init(axes, showsIndicators: showsIndicators) {
            ScrollViewReader { proxy in
                AnyView(content(proxy))
            }
        }
    }
}
