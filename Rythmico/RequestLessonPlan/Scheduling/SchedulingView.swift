import SwiftUI
import Sugar

protocol SchedulingContext {
    func setSchedule(_ schedule: Schedule)
}

struct SchedulingView: View, TestableView {
    final class ViewState: ObservableObject {
        @Published var startDate: Date?
        @Published var startTime = Current.calendar().date(bySetting: .hour, value: 16, of: .referenceDate) ?? .referenceDate
        @Published var duration: Schedule.Duration?
    }

    enum EditingFocus {
        case startDate
        case startTime
        case duration
    }

    @State private(set) var editingFocus: EditingFocus? = .none
    @Namespace private var startDatePickerAnimation

    @ObservedObject private(set)
    var state: ViewState
    var instrument: Instrument
    var context: SchedulingContext

    private static let dateFormatter = Current.dateFormatter(format: .custom("EEEE d MMMM"))
    private let firstAvailableDate = Current.date() + (2, .day)

    var subtitle: [MultiStyleText.Part] {
        "Enter when you want the " +
        "\(instrument.assimilatedName) lessons".style(.bodyBold) +
        " to commence and for how long"
    }

    var startDateText: String { state.startDate.map(Self.dateFormatter.string(from:)) ?? .empty }
    var durationText: String { state.duration.map { "\($0.rawValue) minutes" } ?? .empty }

    private static let scheduleInfoDayFormatter = Current.dateFormatter(format: .custom("EEEE"))
    private static let scheduleInfoAfterDayFormatter = Current.dateFormatter(format: .custom("E d MMMM"))
    private static let scheduleInfoDurationFormatter = Current.dateIntervalFormatter(format: .preset(time: .short, date: .none))
    var scheduleInfoText: String? {
        let startTime = state.startTime
        guard
            let startDate = state.startDate,
            let duration = state.duration,
            let endTime = Current.calendar().date(byAdding: .minute, value: duration.rawValue, to: startTime)
        else {
            return nil
        }
        let day = Self.scheduleInfoDayFormatter.string(from: startDate)
        let afterDay = Self.scheduleInfoAfterDayFormatter.string(from: startDate)
        let time = Self.scheduleInfoDurationFormatter.string(from: startTime, to: endTime)
        return "Lessons will be scheduled every \(day) \(time) after \(afterDay)"
    }

    var nextButtonAction: Action? {
        guard
            let startDate = state.startDate,
            let startDateAndTime = Date(date: startDate, time: state.startTime),
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
                    VStack(alignment: .leading, spacing: .spacingMedium) {
                        HeaderContentView(title: "Start Date") {
                            ZStack {
                                if editingFocus != .startDate {
                                    CustomTextField(
                                        "Select a date...",
                                        text: .constant(startDateText),
                                        isEditable: false
                                    )
                                    .onTapGesture(perform: beginEditingStartDate)
                                    .transition(.opacity)
                                    .matchedGeometryEffect(
                                        id: startDatePickerAnimation,
                                        in: startDatePickerAnimation,
                                        properties: .size
                                    )
                                }

                                if editingFocus == .startDate {
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { state.startDate ?? firstAvailableDate },
                                            set: { state.startDate = $0 }
                                        ),
                                        in: PartialRangeFrom(firstAvailableDate),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding([.top, .horizontal], .spacingUnit * 2)
                                    .transition(.opacity)
                                    .matchedGeometryEffect(
                                        id: startDatePickerAnimation,
                                        in: startDatePickerAnimation,
                                        properties: .size
                                    )
                                }
                            }
                            .modifier(RoundedThinOutlineContainer(padded: false))
                        }

                        HStack(spacing: .spacingExtraSmall) {
                            HeaderContentView(title: "Time") {
                                DatePicker("", selection: $state.startTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(GraphicalDatePickerStyle())
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

                        if let scheduleInfoText = scheduleInfoText {
                            InfoBanner(text: scheduleInfoText)
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
        .accentColor(.rythmicoPurple)
        .animation(.easeInOut(duration: .durationMedium), value: editingFocus)
        .testable(self)
    }

    func beginEditingStartDate() {
        editingFocus = .startDate

        if state.startDate == nil {
            state.startDate = firstAvailableDate
        }
    }

    func beginEditingStartTime() {
        editingFocus = .startTime
    }

    func beginEditingDuration() {
        editingFocus = .duration

        if state.duration == nil {
            state.duration = .oneHour
        }
    }

    func endEditing() {
        editingFocus = .none
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
        .previewDevices()
    }
}
#endif
