import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D

    init(centerCoordinate: Binding<CLLocationCoordinate2D> = .constant(.init(latitude: 51.5062, longitude: -0.1248))) {
        self._centerCoordinate = centerCoordinate
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 150, longitudinalMeters: 150)
    }
}
