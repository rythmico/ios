import SwiftUI
import SFSafeSymbols

struct MainTabView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection) {
            Text("First View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemSymbol: .musicNoteList).font(.system(size: 21, weight: .bold))
                        Text("First")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemSymbol: .personFill).font(.system(size: 21, weight: .semibold))
                        Text("Second")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
