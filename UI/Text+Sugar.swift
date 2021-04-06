import SwiftUI
import JoinedText

extension StringProtocol {
    var text: Text { Text(self) }
}

extension Text {
    init(separator: String, @TextBuilder content: () -> [Text]) {
        self.init(separator: Text(separator), content: content)
    }
}

extension TextBuilder {
    public static func buildExpression(_ string: String?) -> [Text] {
        string.map { [Text($0)] } ?? []
    }
}
