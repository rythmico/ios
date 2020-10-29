import SwiftUI

// TODO: remove once SwiftUI implements `hidesBottomBarWhenPushed`.
// For now, on iPhone we wrap TabView into a single NavigationView
// to hide the tab bar when presenting detail views.
// On iPad, height is enough not to interfere with user experience
// so we go with the standard TabView into NavigationView approach.
struct MainViewContent<Tab: Hashable>: View {
    var tabs: [Tab]
    @Binding
    var selection: Tab
    var navigationTitle: KeyPath<Tab, String>
    var leadingItems: [Tab: AnyView]
    var trailingItems: [Tab: AnyView]
    var contents: [Tab: AnyView]
    var tabTitle: KeyPath<Tab, String>
    var tabIcons: [Tab: AnyView]

    init<TabIcon: View, Content: View, LeadingItem: View, TrailingItem: View>(
        tabs: [Tab],
        selection: Binding<Tab>,
        navigationTitle: KeyPath<Tab, String>,
        @ViewBuilder leadingItem: (Tab) -> LeadingItem,
        @ViewBuilder trailingItem: (Tab) -> TrailingItem,
        @ViewBuilder content: (Tab) -> Content,
        tabTitle: KeyPath<Tab, String>,
        @ViewBuilder tabIcons: (Tab) -> TabIcon
    ) {
        self.tabs = tabs
        self._selection = selection
        self.navigationTitle = navigationTitle
        self.leadingItems = tabs.reduce(into: [:]) { result, tab in result[tab] = AnyView(leadingItem(tab)) }
        self.trailingItems = tabs.reduce(into: [:]) { result, tab in result[tab] = AnyView(trailingItem(tab)) }
        self.contents = tabs.reduce(into: [:]) { result, tab in result[tab] = AnyView(content(tab)) }
        self.tabTitle = tabTitle
        self.tabIcons = tabs.reduce(into: [:]) { result, tab in result[tab] = AnyView(tabIcons(tab)) }
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs, id: \.self) { tab in
                NavigationView {
                    contents[tab]
                        .navigationTitle(tab[keyPath: navigationTitle])
                        .navigationBarItems(leading: leadingItems[tab], trailing: trailingItems[tab])
                }
                .navigationViewFixInteractiveDismissal()
                .tag(tab)
                .tabItem {
                    tabIcons[tab]
                    Text(tab[keyPath: tabTitle])
                }
            }
        }
    }
}
