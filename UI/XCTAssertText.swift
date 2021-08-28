import XCTest
import SwiftUI
import ViewInspector

func XCTAssertText(_ text: Text, _ expectedString: String, file: StaticString = #filePath, line: UInt = #line) throws {
    let inspectedText = try text.inspect().text()
    let string = try inspectedText.string()
    XCTAssertEqual(string, expectedString, file: file, line: line)
}
