import FoundationEncore

struct AnalyticsEvent {
    var name: Name
    var props: Props
}

extension AnalyticsEvent {
    struct Name: ExpressibleByStringInterpolation {
        typealias `Protocol` = AnalyticsEventNameProtocol

        let rawValue: String
        init(stringLiteral value: String) {
            self.rawValue = value
        }
    }
    typealias Props = [AnyHashable: Any]
    typealias PropsBuilder = DictionaryBuilder<Props.Key, Props.Value>
}

/// TODO: remove when Result Builders become stateful.
/// This protocol is just a workaround type to pass into
/// `AnalyticsEvent.Builder` to use the `name` property.
/// https://forums.swift.org/t/stateful-result-builders/47242
protocol AnalyticsEventNameProtocol {
    typealias Name = AnalyticsEvent.Name
    static var name: Name { get }
}

extension AnalyticsEvent {
    @resultBuilder
    struct Builder<EventName: AnalyticsEventNameProtocol> {
        typealias Element = (Props.Key, Props.Value)
        typealias Event = AnalyticsEvent

        static func buildArray(_ props: [Props]) -> Props { props.reduce([:], +) }
        static func buildBlock(_ props: Props...) -> Props { props.reduce([:], +) }
        static func buildEither(first props: Props) -> Props { props }
        static func buildEither(second props: Props) -> Props { props }
        static func buildExpression(_ element: Element) -> Props { [element.0: element.1] }
        static func buildExpression(_ props: Props) -> Props { props }
        static func buildFinalResult(_ props: Props) -> Event { Event(name: EventName.name, props: props) }
        static func buildLimitedAvailability(_ props: Props) -> Props { props }
        static func buildOptional(_ props: Props?) -> Props { props ?? [:] }
    }
}
