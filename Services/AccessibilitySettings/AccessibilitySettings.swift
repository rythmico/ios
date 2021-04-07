import UIKit

struct AccessibilitySettings {
    var isVoiceOverOn: () -> Bool
    var interfaceStyle: () -> UIUserInterfaceStyle
    var dynamicTypeSize: () -> UIContentSizeCategory
    var isBoldTextOn: () -> Bool

    init(
        isVoiceOverOn: @autoclosure @escaping () -> Bool,
        interfaceStyle: @autoclosure @escaping () -> UIUserInterfaceStyle,
        dynamicTypeSize: @autoclosure @escaping () -> UIContentSizeCategory,
        isBoldTextOn: @autoclosure @escaping () -> Bool
    ) {
        self.isVoiceOverOn = isVoiceOverOn
        self.interfaceStyle = interfaceStyle
        self.dynamicTypeSize = dynamicTypeSize
        self.isBoldTextOn = isBoldTextOn
    }
}
