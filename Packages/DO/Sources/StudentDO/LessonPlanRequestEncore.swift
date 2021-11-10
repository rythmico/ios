extension Collection where Element == LessonPlanRequest {
    public func filterOpen() -> [LessonPlanRequest] {
        filter {
            switch $0.status {
            case .pending:
                return true
            }
        }
    }
}
