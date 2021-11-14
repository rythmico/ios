import FoundationEncore

extension Address {
    static let stub = Self(
        latitude: 51.580460,
        longitude: -0.119150,
        line1: "Apartment 30",
        line2: "85 Shore Street",
        line3: "",
        line4: "",
        district: "",
        city: "Stoke St Mary",
        state: "",
        postcode: "TA3 0XS",
        country: "England"
    )
}

#if RYTHMICO
import StudentDTO

extension StudentDTO.Address.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }

    static let stub = random()
}

extension StudentDTO.Address {
    static let stub = Self(
        id: .stub,
        latitude: 51.580460,
        longitude: -0.119150,
        line1: "Apartment 30",
        line2: "85 Shore Street",
        line3: "",
        line4: "",
        district: "",
        city: "Stoke St Mary",
        state: "",
        postcode: "TA3 0XS",
        country: "England"
    )
}
#endif
