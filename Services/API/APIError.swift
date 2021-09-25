import CoreDTO
import Foundation

extension CoreDTO.APIError: LocalizedError {
    public var errorDescription: String? { description }
}
