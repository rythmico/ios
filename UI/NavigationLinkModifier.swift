import SwiftUI

extension View {
    func navigationLink<Label: View, Destination: View>(_ link: NavigationLink<Label, Destination>) -> some View {
        self.modifier(NavigationLinkModifier(link: link))
    }
}

private struct NavigationLinkModifier<Label: View, Destination: View>: ViewModifier {
    var link: NavigationLink<Label, Destination>

    func body(content: Content) -> some View {
        ZStack {
            content
            link.frame(width: 0).opacity(0)
        }
    }
}
