#if canImport(MapKit)
import SwiftUI
import MapKit

public struct NonInteractiveMap: View {
    let coordinate: CLLocationCoordinate2D
    let regionMeters: CLLocationDistance
    let showsPin: Bool

    public init(
        coordinate: CLLocationCoordinate2D,
        regionMeters: CLLocationDistance,
        showsPin: Bool
    ) {
        self.coordinate = coordinate
        self.regionMeters = regionMeters
        self.showsPin = showsPin
    }

    public var body: some View {
        Map(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: regionMeters,
                    longitudinalMeters: regionMeters
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
