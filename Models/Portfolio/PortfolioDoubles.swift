import SwiftUISugar

extension Portfolio: Then {}
extension Portfolio.Training: Then {}

extension Portfolio {
    static let minimalStub = Self(
        age: 29,
        bio: .empty,
        training: [],
        videos: [],
        photos: []
    )

    static let shortStub = Self(
        age: 29,
        bio: """
        Victor is a graduate from The Juilliard School and the Manhattan School of Music where he held full-scholarships.
        """,
        training: [.shortStub],
        videos: [.stub(.red)],
        photos: [.stub(.red), .stub(.green)]
    )

    static let longStub = Self(
        age: 29,
        bio: """
        Callum started playing drums at the age of 10 and started gigging regularly around the UK in his early teens. With his love for all different styles of music, Callum moved to London in 2015 to expend his musical language and network.

        From 2015-2018, Callum took on a Bmus (Degree) in Popular Music performance at BIMM London/London College of Music. In 2019 he started his Jazz Mmus at the Guildhall School of Music and Drama.

        Being a performer and gigging regularly is something that Callum has loved from a young age. But as of recent years, Callum’s growth and passion for teaching and sharing knowledge in drumming is something he deeply believes in and values to his skills as a musician.

        Callum’s extensive drive and passion for music has seen him achieve:

        • Scholarship for Masters at the Guildhall School of Music and Drama.
        • Music Performance (undergrad) Degree (Bmus)
        • Trinity Guildhall Drum Kit grades 1-8.
        • Music and Tech A level, Music GCSE and BTEC level 2.
        • Regularly Gigs all over the UK and Overseas.
        • Performed in landmarks such as The Shard, Tower Bridge, Hilton Park Lane, The Globe, The Barbican, Under the Bridge Chelsea, Camden Roundhouse, The 02 Academy Islington and Shepherds Bush Empire.
        • Played with Motown 60’s Girls group The Velvelettes at the Whitby Motown weekender.
        • Played the Music of Duke Ellington with the Guildhall Jazz Orchestra at the Barbican hall. Yazz Ahmed’s Music with the Guildhall Jazz Orchestra at Milton Court Concert hall, as well as early Big Band Music featuring Giacomo Smith.
        • Attends weekly London Jam nights including the Ronnie Scotts late show.
        • Small drum studio in West London for teaching and practising.
        • Study/Studied under some Londons top musicians and drummers. Also with international drummer; Ralph Rolle from Chic.
        • A massive passion and love for teaching and sharing information.
        • Workshop practitioner for Samba and African drumming and percussion.
        • Knowledge in production, Studio recording and mixing and mastering.

        “Callum Smith is a young man that has a deep passion for drumming [...] Callum’s future as a musician is a bright one. I expect great things from this young man. He is truly on the path that is solid.” — Ralph Rolle (Chic, Prince, Bono, Sting, D’Angelo...)
        """,
        training: [.longStubA, .longStubB],
        videos: [.stub(.red), .stub(.green), .stub(.blue), .stub(.purple)],
        photos: [.stub(.red), .stub(.green), .stub(.blue), .stub(.purple)]
    )
}

extension Portfolio.Training {
    static let shortStub = Self(
        title: "The Juilliard School",
        description: "",
        duration: nil
    )

    static let mediumStubA = shortStub.with {
        $0.description = "Master of Music Scholarship"
    }

    static let mediumStubB = shortStub.with {
        $0.duration = Duration(fromYear: 2014, toYear: nil)
    }

    static let longStubA = shortStub.with {
        $0.description = "Master of Music Scholarship"
        $0.duration = Duration(fromYear: 2014, toYear: 2016)
    }

    static let longStubB = shortStub.with {
        $0.description = "Undergraduate Music Scholarship"
        $0.duration = Duration(fromYear: 2011, toYear: 2014)
    }
}

extension Array where Element == Portfolio.Training {
    static let stub: Self = [
        .shortStub,
        .mediumStubA,
        .mediumStubB,
        .longStubA,
        .longStubB,
    ]
}

extension Portfolio.Video {
    static func stub(_ color: UIColor) -> Self {
        .init(
            source: .youtube(videoId: "FnW2OWH8Tac"),
//            source: .directURL(URL(string: "https://bit.ly/swswift")!),
            thumbnailURL: .image(UIImage(color: color))
        )
    }
}

extension Portfolio.Photo {
    static func stub(_ color: UIColor) -> Self {
        .init(
            photoURL: .image(UIImage(color: color)),
            thumbnailURL: .image(UIImage(color: color))
        )
    }
}
