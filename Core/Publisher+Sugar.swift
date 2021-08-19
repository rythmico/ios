import Combine

extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        self.map { _ in }
    }
}
