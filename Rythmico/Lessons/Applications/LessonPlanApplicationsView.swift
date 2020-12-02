import SwiftUI

struct LessonPlanApplicationsView: View {
    private var lessonPlan: LessonPlan
    private var applications: [LessonPlan.Application]
    @ObservedObject
    private var state = Current.state
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
        "All \(instrument) tutors charge a standard rate of £\(lessonPlan.schedule.duration) per lesson"
    }

    var instrument: String {
        lessonPlan.instrument.name.lowercased(with: Current.locale)
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
                applications: applications
            )
        }
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: state.lessonsContext.reviewingApplication, perform: onSelectedApplicationChanged)
        .onAppear(perform: onAppear)
    }

    private func onSelectedApplicationChanged(_ application: LessonPlan.Application?) {
        if application != nil { shouldShowInfoBannerOnAppear = true }
    }

    private func onAppear() {
        if shouldShowInfoBannerOnAppear { isShowingInfoBanner = true }
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
            TutorAvatarView(application.tutor, mode: .thumbnail)
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
