import SwiftUI

extension View {
    @ViewBuilder
    func hiddenNavigationLink<Label: View, Destination: View>(_ link: NavigationLink<Label, Destination>) -> some View {
        self.modifier(HiddenNavigationLinkModifier(link: link))
    }
}

private struct HiddenNavigationLinkModifier<Label: View, Destination: View>: ViewModifier {
    var link: NavigationLink<Label, Destination>

    func body(content: Content) -> some View {
        ZStack {
            content
            link.frame(width: 0).opacity(0)
        }
    }
}
