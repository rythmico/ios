import SwiftUI
import Introspect
import FoundationSugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

struct SchedulingView: View, EditableView, TestableView {
    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var duration: Schedule.Duration?

        @Published var hasFocusedDate = false
        @Published var hasFocusedTime = false
    }

    enum EditingFocus: EditingFocusEnum {
        case textField // unused but required
        case startDate
        case startTime
        case duration
    }

    @StateObject
    var editingCoordinator = EditingCoordinator(endEditingOnBackgroundTap: false)
    @Namespace
    private var startDatePickerAnimation

    @ObservedObject private(set)
    var state: ViewState
    var instrument: Instrument
    var context: SchedulingContext

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(date: .none, time: .short))

    private let firstAvailableDate = Current.date() + (2, .day) <- (0, [.minute, .second, .nanosecond])

    var subtitle: [MultiStyleText.Part] {
        "Enter when you want the " +
        "\(instrument.assimilatedName) lessons".style(.bodyBold) +
        " to commence and for how long"
    }

    var startDateText: String? { state.hasFocusedDate ? state.startDate.map(Self.dateFormatter.string(from:)) : nil }
    var startTimeText: String? { state.hasFocusedTime ? state.startDate.map(Self.timeFormatter.string(from:)) : nil }
    var durationText: String? { state.duration.map { "\($0.rawValue) minutes" } }

    private static let scheduleInfoDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let scheduleInfoAfterDayFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private static let scheduleInfoDurationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    var scheduleInfoText: String? {
        guard
            state.hasFocusedDate,
            state.hasFocusedTime,
            let startDate = state.startDate,
            let duration = state.duration,
            let endDate = Current.calendar().date(byAdding: .minute, value: duration.rawValue, to: startDate)
        else {
            return nil
        }
        let day = Self.scheduleInfoDayFormatter.string(from: startDate)
        let time = Self.scheduleInfoDurationFormatter.string(from: startDate, to: endDate)
        let afterDay = Self.scheduleInfoAfterDayFormatter.string(from: startDate)
        return "Lessons will be scheduled every \(day) \(time) after \(afterDay)"
    }

    var nextButtonAction: Action? {
        guard
            state.hasFocusedDate,
            state.hasFocusedTime,
            let startDate = state.startDate,
            let duration = state.duration
        else {
            return nil
        }

        return {
            context.setSchedule(Schedule(startDate: startDate, duration: duration))
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView { ScrollViewReader { proxy in
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
                                CustomEditableTextField(
                                    placeholder: "Time...",
                                    text: startTimeText,
                                    isEditing: editingFocus == .startTime,
                                    editAction: { beginEditingStartTime(scrollViewProxy: proxy) }
                                ) {
                                    if let startDateBinding = Binding($state.startDate) {
                                        DatePicker(
                                            "",
                                            selection: startDateBinding,
                                            displayedComponents: .hourAndMinute
                                        )
                                        .datePickerStyle(GraphicalDatePickerStyle())
                                        .introspectDatePicker {
                                            $0.minuteInterval = 5
                                            $0.becomeFirstResponder()
                                        }
                                    }
                                }
                                .id(EditingFocus.startTime)
                            }

                            HeaderContentView(title: "Duration") {
                                NonEditableTextField(
                                    placeholder: "Duration...",
                                    text: durationText,
                                    tapAction: beginEditingDuration
                                )
                            }
                        }

                        if let scheduleInfoText = scheduleInfoText {
                            InfoBanner(text: scheduleInfoText)
                        }
                    }
                    .padding([.trailing, .bottom], .spacingMedium)
                }}
                .padding(.leading, .spacingMedium)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            Button("Next", action: action).primaryStyle()
                        }
                        .zIndex(0)
                    }

                    if editingFocus == .duration {
                        if let durationBinding = Binding($state.duration) {
                            FloatingInputView(doneAction: endEditing) {
                                BetterPicker(
                                    selection: durationBinding,
                                    formatter: { "\($0.rawValue) minutes" }
                                )
                            }
                            .zIndex(1)
                        }
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
    func beginEditingStartTime(scrollViewProxy proxy: ScrollViewProxy) {
        editingFocus = .startTime
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut) {
                proxy.scrollTo(EditingFocus.startTime, anchor: .top)
            }
        }
    }
    func beginEditingDuration() { editingFocus = .duration }

    func onEditingFocusChanged(_ focus: EditingFocus?) {
        guard let focus = focus else { return }
        switch focus {
        case .textField: // unused
            break
        case .startDate:
            state.hasFocusedDate = true
            state.startDate ??= firstAvailableDate
        case .startTime:
            state.hasFocusedTime = true
            state.startDate ??= firstAvailableDate
        case .duration:
            state.duration ??= .oneHour
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
