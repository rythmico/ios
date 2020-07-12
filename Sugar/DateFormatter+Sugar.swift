import Foundation

extension DateFormatter {
    public enum Format {
        case time(Style)
        case date(Style)
        case custom(String)
    }

    public convenience init(format: Format) {
        self.init()
        switch format {
        case .time(let style):
            self.timeStyle = style
        case .date(let style):
            self.dateStyle = style
        case .custom(let format):
            self.dateFormat = format
        }
    }
}
