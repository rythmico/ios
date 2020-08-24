import SwiftUI
import SwiftUIMapView
import MapKit

struct StaticMapView: View {
    static let defaultCoordinate = CLLocationCoordinate2D(latitude: 51.5062, longitude: -0.1248)

    var coordinate = Self.defaultCoordinate
    var showsCoordinate: Bool

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
            showsUserLocation: false,
            annotations: showsCoordinate ? [MapAnnotation(coordinate: coordinate)] : []
        )
    }
}

private final class MapAnnotation: NSObject, MapViewAnnotation {
    let clusteringIdentifier: String? = nil
    let glyphImage: UIImage? = nil
    let tintColor: UIColor? = nil

    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
