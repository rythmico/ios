import SwiftUIEncore

struct MainViewContent<Tab: Hashable>: View {
    var tabs: [Tab]
    @Binding
    var selection: Tab
    var contents: [Tab: AnyView]
    var tabTitle: KeyPath<Tab, String>
    var tabIcons: [Tab: AnyView]

    init<TabIcon: View, Content: View>(
        tabs: [Tab],
        selection: Binding<Tab>,
        @ViewBuilder content: (Tab) -> Content,
        tabTitle: KeyPath<Tab, String>,
        @ViewBuilder tabIcons: (Tab) -> TabIcon
    ) {
        self.tabs = tabs
        self._selection = selection
        self.contents = tabs.reduce(into: [:]) { result, tab in result[tab] = content(tab).eraseToAnyView() }
        self.tabTitle = tabTitle
        self.tabIcons = tabs.reduce(into: [:]) { result, tab in result[tab] = tabIcons(tab).eraseToAnyView() }
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs, id: \.self) { tab in
                contents[tab]
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
