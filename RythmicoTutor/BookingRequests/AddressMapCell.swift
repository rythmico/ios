import SwiftUI
import MapKit

struct AddressMapCell: View {
    @State
    private var isMapOpeningSheetPresented = false
    private func presentMapActionSheet() { isMapOpeningSheetPresented = true }
    @State
    private var mapOpeningError: Error?

    var addressInfo: BookingApplication.AddressInfo

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                StaticMapView(coordinate: coordinate)
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: .spacingUnit * 2, style: .continuous))
                    .onTapGesture(perform: presentMapActionSheet)
                VStack(alignment: .leading, spacing: .spacingUnit * 1.5) {
                    if isFullAddress {
                        Text("Address")
                            .foregroundColor(.primary)
                            .font(.body)
                    }
                    Text(address)
                        .foregroundColor(isFullAddress ? .secondary : .primary)
                        .font(.body)
                }
            }
            .padding(.vertical, .spacingUnit * 2)

            if isFullAddress {
                Button("Get Directions", action: presentMapActionSheet)
            }
        }
        .mapOpeningSheet(
            isPresented: $isMapOpeningSheetPresented,
            intent: .search(query: searchQuery),
            error: $mapOpeningError
        )
    }

    private var coordinate: CLLocationCoordinate2D {
        switch addressInfo {
        case .postcode:
            return StaticMapView.defaultCoordinate
        case .address(let address):
            return CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        }
    }

    private var address: String {
        switch addressInfo {
        case .postcode(let postcode):
            return postcode
        case .address(let address):
            return address.condensedFormattedString
        }
    }

    private var isFullAddress: Bool {
        switch addressInfo {
        case .postcode:
            return false
        case .address:
            return true
        }
    }

    private var searchQuery: String {
        switch addressInfo {
        case .postcode(let postcode):
            return postcode
        case .address(let address):
            return address.searchQueryString
        }
    }
}

private extension Address {
    var searchQueryString: String {
        [
            line1,
            line2,
            line3,
            line4,
            city,
            postcode,
            country,
        ]
        .filter(\.isEmpty.not).joined(separator: ", ")
    }
}

#if DEBUG
struct AddressMapCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Form {
                AddressMapCell(addressInfo: .postcode("N8"))
            }
            Form {
                AddressMapCell(addressInfo: .address(.stub))
            }
        }
        .previewLayout(.fixed(width: 370, height: 400))
    }
}
#endif
