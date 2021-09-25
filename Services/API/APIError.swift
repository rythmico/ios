import CoreDTO
import Foundation

extension CoreDTO.APIErrorOf: LocalizedError {
    public var errorDescription: String? { description }
}
