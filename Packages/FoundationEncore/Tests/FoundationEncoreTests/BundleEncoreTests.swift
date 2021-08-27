import XCTest
import FoundationEncore

final class BundleEncoreTests: XCTestCase {
    func testIdVersionBuild() {
        BundleStub(id: "com.example.foobar", version: "4.2.0", build: "321") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, "com.example.foobar")
            XCTAssertEqual(bundle.version, Version(major: 4, minor: 2, patch: 0))
            XCTAssertEqual(bundle.build?.rawValue, 321)
        }
        BundleStub(id: nil, version: "4.2.0", build: "321") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, Version(major: 4, minor: 2, patch: 0))
            XCTAssertEqual(bundle.build?.rawValue, 321)
        }
        BundleStub(id: nil, version: nil, build: "321") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, nil)
            XCTAssertEqual(bundle.build?.rawValue, 321)
        }
        BundleStub(id: nil, version: nil, build: nil) => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, nil)
            XCTAssertEqual(bundle.build?.rawValue, nil)
        }
    }

    func testIdVersionBuildEdgeCases() {
        BundleStub(id: "", version: "", build: "") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, nil)
            XCTAssertEqual(bundle.build?.rawValue, nil)
        }
        BundleStub(id: "", version: "420", build: "abc") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, nil)
            XCTAssertEqual(bundle.build?.rawValue, nil)
        }
        BundleStub(id: "", version: "4.2", build: "-5") => { bundle in
            XCTAssertEqual(bundle.id?.rawValue, nil)
            XCTAssertEqual(bundle.version, nil)
            XCTAssertEqual(bundle.build?.rawValue, nil)
        }
    }
}

final class BundleStub: BundleProtocol {
    let infoDictionary: [String : Any]?

    init(id: String?, version: String?, build: String?) {
        infoDictionary = [
            "CFBundleIdentifier": id,
            "CFBundleShortVersionString": version,
            "CFBundleVersion": build,
        ]
        .compacted()
    }
}
