import SwiftUI

struct LessonPlanApplicationsView: View, RoutableView {
    private enum Const {
        static let avatarSize = .spacingUnit * 14
    }

    @Environment(\.presentationMode)
    private var presentationMode

    private var lessonPlan: LessonPlan
    private var applications: [LessonPlan.Application]

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

    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: .spacingSmall),
            GridItem(.flexible(), spacing: .spacingSmall)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacingSmall) {
            TitleContentView(title: "Tutors Available") {
                InfoBanner(text: priceInfo)
            }
            .padding(.horizontal, .spacingMedium)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, alignment: .center, spacing: .spacingSmall) {
                    ForEach(applications, id: \.self) { application in
                        VStack(spacing: .spacingExtraSmall) {
                            LessonPlanTutorAvatarView(application.tutor, thumbnail: true)
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
                .padding(.top, .spacingUnit * 2)
                .padding(.horizontal, .spacingMedium)
            }
        }
        .padding(.top, .spacingExtraSmall)
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarBackButtonItem(BackButton(title: "Lessons", action: back))
        .routable(self)
    }

    private func back() {
        presentationMode.wrappedValue.dismiss()
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

#if DEBUG
struct LessonPlanApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationsView(.reviewingJackGuitarPlanStub)
//            .environment(\.sizeCategory, ContentSizeCategory.accessibilityExtraLarge)
    }
}
#endif
