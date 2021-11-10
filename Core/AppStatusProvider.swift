import Foundation

class AppStatusProvider: ObservableObject {
    @Published var isAppOutdated: Bool = false
}
