import SwiftUI

extension View {
    func inset(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        Set<Edge>(edges).reduce(AnyView(self)) { view, edge in
            let rectangle = Rectangle().fill(Color.clear)
            let length = length ?? 16
            switch edge {
            case .top:
                return AnyView(
                    VStack(spacing: 0) {
                        rectangle.frame(height: length)
                        view
                    }
                )
            case .bottom:
                return AnyView(
                    VStack(spacing: 0) {
                        view
                        rectangle.frame(height: length)
                    }
                )
            case .leading:
                return AnyView(
                    HStack(spacing: 0) {
                        rectangle.frame(width: length)
                        view
                    }
                )
            case .trailing:
                return AnyView(
                    HStack(spacing: 0) {
                        view
                        rectangle.frame(width: length)
                    }
                )
            }
        }
    }
}

private extension Set where Element == Edge {
    init(_ edgeSet: Edge.Set) {
        var array = [Edge]()
        for option in Edge.Set.allOptions {
            if edgeSet.contains(option) {
                switch option {
                case .all:
                    array.append(contentsOf: [.top, .leading, .trailing, .bottom])
                case .vertical:
                    array.append(contentsOf: [.top, .bottom])
                case .horizontal:
                    array.append(contentsOf: [.leading, .trailing])
                case .top:
                    array.append(contentsOf: [.top])
                case .bottom:
                    array.append(contentsOf: [.bottom])
                case .leading:
                    array.append(contentsOf: [.leading])
                case .trailing:
                    array.append(contentsOf: [.trailing])
                default:
                    continue
                }
            }
        }
        self = Set(array)
    }
}

private extension Edge.Set {
    static let allOptions: [Edge.Set] = [
        .all,
        .vertical,
        .horizontal,
        .top,
        .bottom,
        .leading,
        .trailing
    ]
}

struct ViewWithInsetsPreview: PreviewProvider {
    static var previews: some View {
        return ForEach(0..<Edge.Set.allOptions.count) { index in
            Rectangle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .inset(Edge.Set.allOptions[index])
                .background(Color.green)
        }
    }
}

