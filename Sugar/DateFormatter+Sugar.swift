import Foundation

extension DateFormatter {
    public enum Format {
        case time(Style)
        case date(Style)
        case custom(String)
    }

    public func setFormat(_ format: Format) {
        switch format {
        case .time(let style):
            timeStyle = style
        case .date(let style):
            dateStyle = style
        case .custom(let format):
            dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: locale) ?? format
        }
    }
}
