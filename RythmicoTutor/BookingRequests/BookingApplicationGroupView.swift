import SwiftUI

struct BookingApplicationGroupView: View {
    let applications: [BookingApplication]
    let status: BookingApplication.Status

    var body: some View {
        List {
            BookingApplicationSection(applications: applications, status: status)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
    }

    private var title: String {
        [status.title, "Requests"].spaced()
    }
}

#if DEBUG
struct BookingApplicationGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(BookingApplication.Status.allCases, id: \.self) {
            BookingApplicationGroupView(applications: .stub, status: $0)
                .previewLayout(.fixed(width: 370, height: 170))
        }
    }
}
#endif
