extension LessonPlanRequestSchedule {
    public var timeInterval: TimeOnlyInterval {
        TimeOnlyInterval(start: time, end: try! time + duration)
    }
}
