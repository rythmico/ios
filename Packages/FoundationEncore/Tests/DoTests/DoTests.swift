import XCTest
import Do

class DoTests: XCTestCase {
    func testDo() {
        UserDefaults.standard => {
            $0.removeObject(forKey: "username")
            $0.set("foobar", forKey: "username")
        }
        XCTAssertEqual(UserDefaults.standard.string(forKey: "username"), "foobar")
    }

    func testOptionalDo() {
        Optional(UserDefaults.standard) ?=> {
            $0.removeObject(forKey: "username")
            $0.set("foobar", forKey: "username")
        }
        XCTAssertEqual(UserDefaults.standard.string(forKey: "username"), "foobar")
    }

    func testThrowingDo() {
        XCTAssertThrowsError(
            try NSObject() => { _ in
                throw NSError(domain: "", code: 0)
            }
        )
    }

    func testThrowingOptionalDo() {
        XCTAssertThrowsError(
            try Optional(NSObject()) ?=> { _ in
                throw NSError(domain: "", code: 0)
            }
        )
    }

    func testMutateStruct() {
        struct User {
            var name: String?
            var email: String?
        }
        var user = User() => {
            $0.name = "foobar"
            $0.email = "deadbeef@gmail.com"
        }
        user = user => (\.email, "foobar@gmail.com")
        XCTAssertEqual(user.name, "foobar")
        XCTAssertEqual(user.email, "foobar@gmail.com")
    }

    func testMutateOptionalStruct() {
        struct User {
            var name: String?
            var email: String?
        }
        var user = Optional(User()) ?=> {
            $0.name = "foobar"
            $0.email = "deadbeef@gmail.com"
        }
        user = user ?=> (\.email, "foobar@gmail.com")
        XCTAssertEqual(user?.name, "foobar")
        XCTAssertEqual(user?.email, "foobar@gmail.com")
    }

    func testMutateArray() {
        let array = [1, 2, 3] => {
            $0.append(4)
        }
        XCTAssertEqual(array, [1, 2, 3, 4])
    }

    func testMutateOptionalArray() {
        let array = Optional([1, 2, 3]) ?=> {
            $0.append(4)
        }
        XCTAssertEqual(array, [1, 2, 3, 4])
    }

    func testMutateDictionary() {
        let dict = ["Korea": "Seoul", "Japan": "Tokyo"] => {
            $0["China"] = "Beijing"
        }
        XCTAssertEqual(dict, ["Korea": "Seoul", "Japan": "Tokyo", "China": "Beijing"])
    }

    func testMutateOptionalDictionary() {
        let dict = Optional(["Korea": "Seoul", "Japan": "Tokyo"]) ?=> {
            $0["China"] = "Beijing"
        }
        XCTAssertEqual(dict, ["Korea": "Seoul", "Japan": "Tokyo", "China": "Beijing"])
    }

    func testMutateSet() {
        let set = Set(["A", "B", "C"]) => {
            $0.insert("D")
        }
        XCTAssertEqual(set, Set(["A", "B", "C", "D"]))
    }

    func testMutateOptionalSet() {
        let set = Optional(Set(["A", "B", "C"])) ?=> {
            $0.insert("D")
        }
        XCTAssertEqual(set, Set(["A", "B", "C", "D"]))
    }

    func testMutateClass() {
        let queue = OperationQueue() => {
            $0.name = "awesome"
            $0.maxConcurrentOperationCount = 2
        }
        queue => (\.maxConcurrentOperationCount, 5)
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)
    }

    func testMutateOptionalClass() {
        let queue = Optional(OperationQueue()) ?=> {
            $0.name = "awesome"
            $0.maxConcurrentOperationCount = 2
        }
        queue ?=> (\.maxConcurrentOperationCount, 5)
        XCTAssertEqual(queue?.name, "awesome")
        XCTAssertEqual(queue?.maxConcurrentOperationCount, 5)
    }

    func testAssignToStruct() {
        struct User {
            var name: String?
            var email: String = "deadbeef@gmail.com"
        }
        var user = User()
        "foobar" => (assignTo: /&user, \.name)
        "foobar@gmail.com" => (assignTo: /&user, \.email)
        XCTAssertEqual(user.name, "foobar")
        XCTAssertEqual(user.email, "foobar@gmail.com")
    }

    func testAssignOptionalToStruct() {
        struct User {
            var name: String?
            var email: String = "deadbeef@gmail.com"
        }
        var user = User()
        Optional("foobar") ?=> (assignTo: /&user, \.name)
        Optional("foobar@gmail.com") ?=> (assignTo: /&user, \.email)
        XCTAssertEqual(user.name, "foobar")
        XCTAssertEqual(user.email, "foobar@gmail.com")
    }

    func testAssignToClass() {
        var queue = OperationQueue()
        ("awe" + "some") => (assignTo: /&queue, \.name)
        (2 * 2) => (assignTo: /&queue, \.maxConcurrentOperationCount)
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 4)
    }

    func testAssignOptionalToClass() {
        var queue = OperationQueue()
        Optional("awesome") ?=> (assignTo: /&queue, \.name)
        Optional(5) ?=> (assignTo: /&queue, \.maxConcurrentOperationCount)
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)
    }
}
