import SwiftUI
import Sugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

// TODO: refactor date logic into a manager class from
// which to observe available dates and times, with injectable calendar.
struct SchedulingView: View, TestableView {
    fileprivate enum Const {
        static let earliestStartTime = Date(timeIntervalSinceReferenceDate: 0).setting(hour: 8) // 08:00
        static let fieldDateFormat = "EEEE d MMMM"
        static let fieldTimeFormat = "H:mm"
        static let pickerDateFormat = "E d MMM yyyy"
        static let pickerTimeFormat = "H:mm"
    }

    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime: Date?
        @Published var duration: Duration?
    }

    @ObservedObject private(set) var state: ViewState

    enum EditingFocus {
        case none
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus = .none

    private let instrument: Instrument
    private let context: SchedulingContext
    private let dateFormatter = DateFormatter().then { $0.dateFormat = Const.fieldDateFormat }
    private let timeFormatter = DateFormatter().then { $0.dateFormat = Const.fieldTimeFormat }
    private let availableDates = [Date](byAdding: 1, .day, from: Date() + (1, .day), times: 182)
    private let availableTimes = [Date](byAdding: 30, .minute, from: Const.earliestStartTime, times: 22)
    private var availablePickableDates: [PickableDate] { availableDates.map(dateToPickableDate) }
    private var availablePickableTimes: [PickableDate] { availableTimes.map(timeToPickableDate) }

    init(
        instrument: Instrument,
        state: ViewState,
        context: SchedulingContext
    ) {
        self.instrument = instrument
        self.state = state
        self.context = context
    }

    var subtitle: [MultiStyleText.Part] {
        "Enter when you want the " + "\(instrument.name) lessons".bold + " to commence and for how long"
    }

    var startDateText: String { state.startDate.map(dateFormatter.string(from:)) ?? .empty }
    var startTimeText: String { state.startTime.map(timeFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration?.optionTitle ?? .empty }

    var nextButtonAction: Action? {
        guard
            let startDate = state.startDate,
            let startTime = state.startTime,
            let startDateAndTime = Date(date: startDate, time: startTime),
            let duration = state.duration
        else {
            return nil
        }

        return {
            self.context.setSchedule(
                Schedule(startDate: startDateAndTime, duration: duration)
            )
        }
    }

    var didAppear: Handler<Self>?
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        TitleContentView(title: "Start Date") {
                            CustomTextField(
                                "Select a date...",
                                text: .constant(startDateText),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture { self.startDateEditingChanged(true) }
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            TitleContentView(title: "Time") {
                                CustomTextField(
                                    "Start time...",
                                    text: .constant(startTimeText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture { self.startTimeEditingChanged(true) }
                            }

                            TitleContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture { self.durationEditingChanged(true) }
                            }
                        }

                        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                            Text("Please note:").rythmicoFont(.callout)
                            Text("Monday-Friday lessons £60 for 45-60 min.").rythmicoFont(.body)
                            Text("Weekend lessons £65 for 45-60 min.").rythmicoFont(.body)
                        }
                    }
                    .inset(.bottom, .spacingMedium)
                    .onBackgroundTapGesture(perform: endEditingAllFields)
                }

                ZStack(alignment: .bottom) {
                    nextButtonAction.map {
                        FloatingButton(title: "Next", action: $0).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isStartDate {
                        FloatingPicker(
                            options: availablePickableDates,
                            selection: Binding(
                                get: { self.state.startDate.map(dateToPickableDate) ?? self.availablePickableDates[0] },
                                set: { self.state.startDate = $0.date }
                            ),
                            doneButtonAction: { self.startDateEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isStartTime {
                        FloatingPicker(
                            options: availablePickableTimes,
                            selection: Binding(
                                get: { self.state.startTime.map(timeToPickableDate) ?? self.availablePickableTimes[0] },
                                set: { self.state.startTime = $0.date }
                            ),
                            doneButtonAction: { self.startDateEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }

                    if editingFocus.isDuration {
                        FloatingPicker(
                            selection: Binding(
                                get: { self.state.duration ?? .fortyFiveMinutes },
                                set: { self.state.duration = $0 }
                            ),
                            doneButtonAction: { self.durationEditingChanged(false) }
                        ).padding(.horizontal, -.spacingMedium)
                    }
                }
            }
            .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        }
        .onAppear { self.didAppear?(self) }
    }

    func startDateEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .startDate : .none

        if isEditing, state.startDate == nil {
            state.startDate = availableDates[0]
        }
    }

    func startTimeEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .startTime : .none

        if isEditing, state.startTime == nil {
            state.startTime = availableTimes[0]
        }
    }

    func durationEditingChanged(_ isEditing: Bool) {
        editingFocus = isEditing ? .duration : .none

        if isEditing, state.duration == nil {
            state.duration = .fortyFiveMinutes
        }
    }

    func endEditingAllFields() {
        editingFocus = .none
    }
}

private func dateToPickableDate(_ date: Date) -> PickableDate {
    PickableDate(date: date, format: SchedulingView.Const.pickerDateFormat)
}

private func timeToPickableDate(_ time: Date) -> PickableDate {
    PickableDate(date: time, format: SchedulingView.Const.pickerTimeFormat)
}

struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        SchedulingView(
            instrument: .guitarStub,
            state: .init(),
            context: RequestLessonPlanContext()
        ).environment(\.locale, .init(identifier: "en_GB"))
    }
}
