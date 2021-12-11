import MapKit
import TutorDO
import SwiftUIEncore

struct AddressMapCell: View {
    @State
    private var isMapOpeningSheetPresented = false
    private func presentMapActionSheet() { isMapOpeningSheetPresented = true }
    @State
    private var mapOpeningError: Error?

    enum Source: Hashable {
        case partialAddress(LessonPlanRequest.PartialAddress)
        case fullAddress(Address)
    }

    let source: Source

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: .grid(3)) {
                Container(
                    style: .init(fill: .clear, shape: .squircle(radius: .grid(2), style: .continuous), border: .none),
                    content: {
                        NonInteractiveMap(
                            coordinate: coordinate,
                            regionMeters: regionMeters,
                            showsPin: isFullAddress
                        )
                    }
                )
                .frame(height: 160)
                .onTapGesture(perform: presentMapActionSheet)

                VStack(alignment: .leading, spacing: .grid(1.5)) {
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
            .padding(.vertical, .grid(2))

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
        switch source {
        case .partialAddress(let partialAddress):
            return CLLocationCoordinate2D(latitude: partialAddress.latitude, longitude: partialAddress.longitude)
        case .fullAddress(let address):
            return CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
        }
    }

    private var regionMeters: CLLocationDistance {
        switch source {
        case .partialAddress:
            return 500
        case .fullAddress:
            return 150
        }
    }

    private var address: String {
        switch source {
        case .partialAddress(let partialAddress):
            return partialAddress.districtCode
        case .fullAddress(let address):
            return address.formatted(style: .multilineCompact)
        }
    }

    private var isFullAddress: Bool {
        switch source {
        case .partialAddress:
            return false
        case .fullAddress:
            return true
        }
    }

    private var searchQuery: String {
        switch source {
        case .partialAddress(let partialAddress):
            return partialAddress.districtCode
        case .fullAddress(let address):
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
        .filter(\.isEmpty.not)
        .joined(separator: .comma + .whitespace)
    }
}

#if DEBUG
struct AddressMapCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            List {
                AddressMapCell(source: .partialAddress(.stub))
            }
            .listStyle(GroupedListStyle())

            List {
                AddressMapCell(source: .fullAddress(.stub))
            }
            .listStyle(GroupedListStyle())
        }
        .previewLayout(.fixed(width: 370, height: 400))
    }
}
#endif
