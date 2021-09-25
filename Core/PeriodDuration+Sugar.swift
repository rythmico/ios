import FoundationEncore

extension PeriodDuration {
    func formattedString(
        allowedUnits: NSCalendar.Unit = [.hour, .minute],
        style: DateComponentsFormatter.UnitsStyle = .full,
        includesTimeRemainingPhrase: Bool = false
    ) -> String {
        Current.dateComponentsFormatter(
            allowedUnits: allowedUnits,
            style: style,
            includesTimeRemainingPhrase: includesTimeRemainingPhrase
        ).string(from: self.asDateComponents) !! preconditionFailure("nil for input '\(self)'")
    }
}
