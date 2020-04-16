import SwiftUI

extension Animation {
    private enum Const {
        static let rigidDurationToSpeedFactor: Double = 0.3*1.45 // 0.3s -> 1.45x speed
        static let dampingDurationToSpeedFactor: Double = 0.15*2 // 0.15s -> 2x speed
    }

    enum SpringType {
        case rigid
        case damping
    }

    static func rythmicoSpring(duration: Double, type: SpringType = .rigid) -> Animation {
        switch type {
        case .rigid:
            return Animation
                .spring(response: 0.425, dampingFraction: 1, blendDuration: 0)
                .speed(Const.rigidDurationToSpeedFactor / duration)
        case .damping:
            return Animation
                .interpolatingSpring(mass: 5, stiffness: 950, damping: 55)
                .speed(Const.dampingDurationToSpeedFactor / duration)
        }

    }
}
