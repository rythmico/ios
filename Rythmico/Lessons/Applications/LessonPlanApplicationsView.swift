import SwiftUI

struct LessonPlanApplicationsView: View, RoutableView {
    @Environment(\.presentationMode)
    private var presentationMode

    private var lessonPlan: LessonPlan
    private var applications: [LessonPlan.Application]
    @State
    private var selectedApplication: LessonPlan.Application?
    @State
    private var shouldShowInfoBannerOnAppear = false
    @State
    private var isShowingInfoBanner = false

    init?(_ lessonPlan: LessonPlan) {
        guard let applications = lessonPlan.status.reviewingValue else {
            return nil
        }
        self.lessonPlan = lessonPlan
        self.applications = applications
    }

    var priceInfo: String {
        "For the dates you’ve selected, all \(instrument) tutors charge a standard rate of £\(price) per lesson"
    }

    var instrument: String {
        lessonPlan.instrument.name.lowercased(with: Current.locale)
    }

    var price: String {
        Current.calendar().isDateInWeekend(lessonPlan.schedule.startDate) ? "65" : "60"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            TitleContentView(title: "Tutors Available") {
                if isShowingInfoBanner {
                    InfoBanner(text: priceInfo)
                }
            }
            .frame(maxWidth: .spacingMax)
            .padding(.horizontal, .spacingMedium)

            LessonPlanApplicationsGridView(
                lessonPlan: lessonPlan,
                applications: applications,
                selectedApplication: $selectedApplication
            )
        }
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .routable(self)
        .onChange(of: selectedApplication, perform: onSelectedApplicationChanged)
        .onAppear(perform: onAppear)
    }

    private func back() {
        presentationMode.wrappedValue.dismiss()
    }

    private func onSelectedApplicationChanged(_ application: LessonPlan.Application?) {
        if application != nil { shouldShowInfoBannerOnAppear = true }
    }

    private func onAppear() {
        if shouldShowInfoBannerOnAppear { isShowingInfoBanner = true }
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .lessons,
             .requestLessonPlan,
             .profile:
            back()
        }
    }
}

struct LessonPlanApplicationCell: View {
    private enum Const {
        static let avatarSize = .spacingUnit * 14
    }

    var application: LessonPlan.Application

    init(_ application: LessonPlan.Application) {
        self.application = application
    }

    var body: some View {
        VStack(spacing: .spacingExtraSmall) {
            LessonPlanTutorAvatarView(application.tutor, mode: .thumbnail)
                .frame(width: Const.avatarSize, height: Const.avatarSize)
            Text(application.tutor.name)
                .rythmicoFont(.bodyBold)
                .foregroundColor(.rythmicoForeground)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.vertical, .spacingExtraLarge)
        .padding(.horizontal, .spacingSmall)
        .frame(maxWidth: .infinity)
        .modifier(RoundedShadowContainer())
    }
}

#if DEBUG
struct LessonPlanApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LessonPlanApplicationsView(.reviewingJackGuitarPlanStub)
        }
//        .environment(\.sizeCategory, .accessibilityExtraLarge)
    }
}
#endif