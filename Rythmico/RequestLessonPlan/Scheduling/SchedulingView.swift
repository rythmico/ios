import SwiftUI
import Introspect
import FoundationSugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

struct SchedulingView: View, EditableView, TestableView {
    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime: Date?
        @Published var duration: Schedule.Duration?

        var startDateAndTime: Date? {
            unwrap(startDate, startTime).map { Date(date: $0, time: $1, calendar: Current.calendar()) }
        }
    }

    enum EditingFocus: EditingFocusEnum {
        case startDate
        case startTime
        case duration

        static var usingKeyboard = [startTime, duration]
    }

    @StateObject
    var editingCoordinator = EditingCoordinator(endEditingOnBackgroundTap: false)

    @ObservedObject private(set)
    var state: ViewState
    var instrument: Instrument
    var context: SchedulingContext

    private let firstAvailableDate = Current.date() + (2, .day)
    private let defaultStartTime = Current.date() <- (0, [.minute, .second, .nanosecond])
    private let defaultDuration: Schedule.Duration = .oneHour

    var subtitle: [MultiStyleText.Part] {
        "Enter when you want the " +
        "\(instrument.assimilatedName) lessons".style(.bodyBold) +
        " to commence and for how long"
    }

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(date: .none, time: .short))

    private static let scheduleInfoDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let scheduleInfoAfterDayFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let scheduleInfoDurationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))

    var startDateText: String? { state.startDate.map(Self.dateFormatter.string(from:)) }
    var startTimeText: String? { state.startTime.map(Self.timeFormatter.string(from:)) }
    var durationText: String? { state.duration?.title }

    var scheduleInfoText: String? {
        guard
            let startDateAndTime = state.startDateAndTime,
            let duration = state.duration,
            let endDateAndTime = Current.calendar().date(byAdding: .minute, value: duration.rawValue, to: startDateAndTime)
        else {
            return nil
        }
        let day = Self.scheduleInfoDayFormatter.string(from: startDateAndTime)
        let time = Self.scheduleInfoDurationFormatter.string(from: startDateAndTime, to: endDateAndTime)
        let afterDay = Self.scheduleInfoAfterDayFormatter.string(from: startDateAndTime)
        return "Lessons will be scheduled every \(day) \(time) after \(afterDay)"
    }

    var nextButtonAction: Action? {
        unwrap(state.startDateAndTime, state.duration).map { startDate, duration in
            { context.setSchedule(Schedule(startDate: startDate, duration: duration)) }
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        HeaderContentView(title: "Start Date") {
                            CustomEditableTextField(
                                placeholder: "Select a date...",
                                text: startDateText,
                                isEditing: editingFocus == .startDate,
                                editAction: beginEditingStartDate
                            ) {
                                if let startDateBinding = Binding($state.startDate) {
                                    DatePicker(
                                        "",
                                        selection: startDateBinding,
                                        in: firstAvailableDate...,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding([.top, .horizontal], .spacingUnit * 2)
                                }
                            }
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            HeaderContentView(title: "Time") {
                                CustomTextField(
                                    "Time...",
                                    text: .constant(startTimeText ?? .empty),
                                    inputMode: DatePickerInputMode(
                                        selection: $state.startTime.or(defaultStartTime),
                                        mode: .time
                                    ),
                                    inputAccessory: .doneButton,
                                    onEditingChanged: onEditingStartTimeChanged
                                ).modifier(RoundedThinOutlineContainer(padded: false))
                            }

                            HeaderContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText ?? .empty),
                                    inputMode: PickerInputMode(
                                        selection: $state.duration.or(defaultDuration),
                                        formatter: \.title
                                    ),
                                    inputAccessory: .doneButton,
                                    onEditingChanged: onEditingDurationChanged
                                ).modifier(RoundedThinOutlineContainer(padded: false))
                            }
                        }

                        if let scheduleInfoText = scheduleInfoText {
                            InfoBanner(text: scheduleInfoText)
                        }
                    }
                    .padding([.trailing, .bottom], .spacingMedium)
                }
                .padding(.leading, .spacingMedium)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            Button("Next", action: action).primaryStyle()
                        }
                        .zIndex(0)
                    }
                }
            }
        }
        .testable(self)
        .accentColor(.rythmicoPurple)
        .onReceive(editingCoordinator.$focus, perform: onEditingFocusChanged)
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
    }

    func beginEditingStartDate() { editingFocus = .startDate }
    func onEditingStartTimeChanged(_ isEditing: Bool) { editingFocus = isEditing ? .startTime : .none }
    func onEditingDurationChanged(_ isEditing: Bool) { editingFocus = isEditing ? .duration : .none }

    func onEditingFocusChanged(_ focus: EditingFocus?) {
        guard let focus = focus else { return }
        switch focus {
        case .startDate:
            state.startDate ??= firstAvailableDate
        case .startTime:
            state.startTime ??= defaultStartTime
        case .duration:
            state.duration ??= defaultDuration
        }
    }
}

#if DEBUG
struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            state: SchedulingView.ViewState(),
            instrument: .guitar,
            context: RequestLessonPlanContext()
        )
    }
}
#endif
