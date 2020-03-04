import Foundation
import struct SwiftUI.Image

struct Instrument: Identifiable, Equatable {
    var id: String
    var name: String
    var icon: Image
}
