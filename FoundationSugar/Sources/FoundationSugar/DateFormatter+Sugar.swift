extension DateFormatter {
    public enum Format {
        case preset(date: Style = .none, time: Style = .none)
        case custom(String)
    }

    public func setFormat(_ format: Format) {
        switch format {
        case .preset(let dateStyle, let timeStyle):
            self.dateStyle = dateStyle
            self.timeStyle = timeStyle
        case .custom(let format):
            dateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: locale) ?? format
        }
    }
}
