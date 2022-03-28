import SwiftUIEncore

struct PhoneNumberCell: View {
    @State
    private var isSheetPresented = false
    private func presentActionSheet() { isSheetPresented = true }
    @State
    private var error: Error?

    var phoneNumber: PhoneNumber

    var body: some View {
        TitleCell(
            title: "Contact Number",
            detail: phoneNumber.formatted(.international),
            detailColor: .accentColor
        )
        .onTapGesture(perform: presentActionSheet)
        .phoneNumberOpeningSheet(
            isPresented: $isSheetPresented,
            phoneNumber: phoneNumber,
            error: $error
        )
    }
}

#if DEBUG
struct PhoneNumberCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                PhoneNumberCell(phoneNumber: .stub)
            }
            .listStyle(GroupedListStyle())
        }
        .previewLayout(.fixed(width: 370, height: 400))
    }
}
#endif
