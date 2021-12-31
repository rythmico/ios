import CoreDTO
import FoundationEncore

enum APIUtils {
    static func url(scheme: String = "https", path: String) -> URL {
        #if LIVE
        let host = "rythmico-api-live.herokuapp.com"
        #else
        let host = "rythmico-api-stage.herokuapp.com"
        #endif

        do {
            return try URL(scheme: scheme, host: host, path: path, queryItems: nil)
        } catch {
            preconditionFailure(error.legibleLocalizedDescription)
        }
    }

    @DictionaryBuilder<String, String>
    static func headers(bearer: UserCredential?, clientInfo: APIClientInfo) -> [String: String] {
        if let bearer = bearer {
            ["Authorization": "Bearer " + bearer.accessToken]
        }
        clientInfo.encodeAsHTTPHeaders()
    }
}
