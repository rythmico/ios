public protocol Flow: ObservableObject {
    associatedtype Step: FlowStep
    var step: Step { get }
}
