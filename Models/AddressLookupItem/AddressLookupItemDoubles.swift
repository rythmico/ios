import CoreDTO
import FoundationEncore

extension AddressLookupResponse {
    static var stub: Self {
        [.stub]
    }
}

extension AddressLookupItem {
    static var stub: Self {
        Self(
            latitude: 0,
            longitude: 0,
            line1: "Apartment 30",
            line2: "85 Shore Street",
            line3: "",
            line4: "",
            city: "Stoke St Mary",
            postcode: "TA3 0XS",
            country: "England"
        )
    }
}
