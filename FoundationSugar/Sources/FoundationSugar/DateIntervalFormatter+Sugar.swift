import Foundation

extension DateIntervalFormatter {
    public enum Format {
        case preset(time: Style, date: Style)
    }

    public func setFormat(_ format: Format) {
        switch format {
        case .preset(let timeStyle, let dateStyle):
            self.timeStyle = timeStyle
            self.dateStyle = dateStyle
        }
    }
}
