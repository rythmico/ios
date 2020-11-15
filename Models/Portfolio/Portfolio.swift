import Foundation

struct Portfolio: Equatable, Decodable, Hashable {
    struct Training: Equatable, Decodable, Hashable {
        struct Duration: Equatable, Decodable, Hashable {
            var fromYear: Int
            var toYear: Int? // nil means til now
        }

        var title: String
        var description: String
        var duration: Duration?
    }

    struct Video: Equatable, Decodable, Hashable {
        var videoURL: URL
        var thumbnailURL: ImageReference
    }

    struct Photo: Equatable, Decodable, Hashable {
        var photoURL: ImageReference
        var thumbnailURL: ImageReference
    }

    var age: Int
    var bio: String
    var training: [Training]
    var videos: [Video]
    var photos: [Photo]
}
