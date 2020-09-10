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
    }

    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime: Date? // TODO: make Time struct
        @Published var duration: Duration?
    }

    @ObservedObject private(set) var state: ViewState

    enum EditingFocus {
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus? = .none

    private let instrument: Instrument
    private let context: SchedulingContext
    private let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .custom("H:mm"))
    private let availableDates = [Date](byAdding: 1, .day, from: Current.date() + (1, .day), times: 182)
    private let availableTimes = [Date](byAdding: 30, .minute, from: Const.earliestStartTime, times: 22)

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
        (UIScreen.main.isLarge && !sizeCategory._isAccessibilityCategory) || editingFocus == .none
            ? "Enter when you want the " + "\(instrument.name) lessons".style(.bodyBold) + " to commence and for how long"
            : .empty
    }

    var startDateText: String { state.startDate.map(dateFormatter.string(from:)) ?? .empty }
    var startTimeText: String { state.startTime.map(timeFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration.map { "\($0.rawValue) minutes" } ?? .empty }

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
            context.setSchedule(
                Schedule(startDate: startDateAndTime, duration: duration)
            )
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        TitleSubtitleContentView(title: "Lesson Schedule", subtitle: subtitle) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacingLarge) {
                        HeaderContentView(title: "Start Date") {
                            CustomTextField(
                                "Select a date...",
                                text: .constant(startDateText),
                                isEditable: false
                            )
                            .modifier(RoundedThinOutlineContainer(padded: false))
                            .onTapGesture(perform: beginEditingStartDate)
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            HeaderContentView(title: "Time") {
                                CustomTextField(
                                    "Start time...",
                                    text: .constant(startTimeText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture(perform: beginEditingStartTime)
                            }

                            HeaderContentView(title: "Duration") {
                                CustomTextField(
                                    "Duration...",
                                    text: .constant(durationText),
                                    isEditable: false
                                )
                                .modifier(RoundedThinOutlineContainer(padded: false))
                                .onTapGesture(perform: beginEditingDuration)
                            }
                        }

                        VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                            Text("Please note:").rythmicoFont(.bodyBold)
                            Text("Mon-Fri lessons £60 for 45-60 min.").rythmicoFont(.body)
                            Text("Weekend lessons £65 for 45-60 min.").rythmicoFont(.body)
                        }
                    }
                    .padding([.trailing, .bottom], .spacingMedium)
                    .onBackgroundTapGesture(perform: endEditing)
                }
                .padding(.leading, .spacingMedium)

                ZStack(alignment: .bottom) {
                    nextButtonAction.map { action in
                        FloatingView {
                            Button("Next", action: action).primaryStyle()
                        }
                        .zIndex(0)
                    }

                    if editingFocus == .startDate {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                options: availableDates,
                                selection: Binding(
                                    get: { state.startDate ?? availableDates[0] },
                                    set: { state.startDate = $0 }
                                ),
                                formatter: { dateFormatter.string(from: $0) }
                            )
                        }
                        .zIndex(1)
                    }

                    if editingFocus == .startTime {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                options: availableTimes,
                                selection: Binding(
                                    get: { state.startTime ?? availableTimes[0] },
                                    set: { state.startTime = $0 }
                                ),
                                formatter: { timeFormatter.string(from: $0) }
                            )
                        }
                        .zIndex(1)
                    }

                    if editingFocus == .duration {
                        FloatingInputView(doneAction: endEditing) {
                            BetterPicker(
                                selection: Binding(
                                    get: { state.duration ?? .fortyFiveMinutes },
                                    set: { state.duration = $0 }
                                ),
                                formatter: { "\($0.rawValue) minutes" }
                            )
                        }
                        .zIndex(1)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .testable(self)
    }

    func beginEditingStartDate() {
        editingFocus = .startDate

        if state.startDate == nil {
            state.startDate = availableDates[0]
        }
    }

    func beginEditingStartTime() {
        editingFocus = .startTime

        if state.startTime == nil {
            state.startTime = availableTimes[0]
        }
    }

    func beginEditingDuration() {
        editingFocus = .duration

        if state.duration == nil {
            state.duration = .fortyFiveMinutes
        }
    }

    func endEditing() {
        editingFocus = .none
    }
}

#if DEBUG
struct SchedulingViewPreview: PreviewProvider {
    static var previews: some View {
        let state = SchedulingView.ViewState()
        state.startDate = .stub
        state.startTime = .stub
        state.duration = .fortyFiveMinutes

        return SchedulingView(
            instrument: .guitar,
            state: state,
            context: RequestLessonPlanContext()
        )
        .environment(\.locale, .init(identifier: "en_GB"))
        .previewDevices()
    }
}
#endif
