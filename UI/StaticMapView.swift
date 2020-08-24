import SwiftUI
import SwiftUIMapView
import MapKit

struct StaticMapView: View {
    static let defaultCoordinate = CLLocationCoordinate2D(latitude: 51.5062, longitude: -0.1248)

    var coordinate = Self.defaultCoordinate

    var body: some View {
        MapView(
            region: .constant(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 150,
                    longitudinalMeters: 150
                )
            ),
            isZoomEnabled: false,
            isScrollEnabled: false,
            showsUserLocation: false
        )
    }
}
