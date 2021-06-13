import SwiftUI
import MapKit

struct StaticMapView: View {
    static let defaultCoordinate = CLLocationCoordinate2D(latitude: 51.5062, longitude: -0.1248)

    var coordinate = Self.defaultCoordinate
    var showsCoordinate: Bool

    var body: some View {
        Map(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 150,
                    longitudinalMeters: 150
                )
            ),
            interactionModes: [],
            showsUserLocation: false,
            userTrackingMode: nil,
            annotationItems: showsCoordinate ? [IdentifiedCoordinate(coordinate)] : [],
            annotationContent: { MapMarker(coordinate: $0.coordinate, tint: nil) }
        )
    }
}

private struct IdentifiedCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D

    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
