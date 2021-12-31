import CoreDTO

extension Array where Element == Instrument {
    static var stub: Self {
        Instrument.KnownID.allCases.map(Instrument.stub)
    }
}

extension Instrument {
    static func stub(_ id: KnownID) -> Self {
        switch id {
        case .guitar:
            return Instrument(id: .guitar, standaloneName: "Guitar", assimilatedName: "Guitar")
        case .drums:
            return Instrument(id: .drums, standaloneName: "Drums", assimilatedName: "Drum")
        case .piano:
            return Instrument(id: .piano, standaloneName: "Piano", assimilatedName: "Piano")
        case .singing:
            return Instrument(id: .singing, standaloneName: "Singing", assimilatedName: "Singing")
        case .bassGuitar:
            return Instrument(id: .bassGuitar, standaloneName: "Bass Guitar", assimilatedName: "Bass Guitar")
        case .saxophone:
            return Instrument(id: .saxophone, standaloneName: "Saxophone", assimilatedName: "Saxophone")
        case .trumpet:
            return Instrument(id: .trumpet, standaloneName: "Trumpet", assimilatedName: "Trumpet")
        case .flute:
            return Instrument(id: .flute, standaloneName: "Flute", assimilatedName: "Flute")
        case .violin:
            return Instrument(id: .violin, standaloneName: "Violin", assimilatedName: "Violin")
        case .harp:
            return Instrument(id: .harp, standaloneName: "Harp", assimilatedName: "Harp")
        }
    }
}
