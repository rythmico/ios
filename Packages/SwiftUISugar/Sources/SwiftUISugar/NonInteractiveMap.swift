#if canImport(MapKit)
import SwiftUI
import MapKit

public struct NonInteractiveMap: View {
    public static let defaultCoordinate = CLLocationCoordinate2D(latitude: 51.5062, longitude: -0.1248)

    private var coordinate: CLLocationCoordinate2D
    private var showsPin: Bool

    public init(
        coordinate: CLLocationCoordinate2D = Self.defaultCoordinate,
        showsPin: Bool
    ) {
        self.coordinate = coordinate
        self.showsPin = showsPin
    }

    public var body: some View {
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
            annotationItems: showsPin ? [IdentifiedCoordinate(coordinate)] : [],
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
#endif
