import XCTest
@testable import DangerJazzy
@testable import Danger
@testable import DangerFixtures

final class DangerJazzyTests: XCTestCase {

    override func tearDown() {
        resetDangerResults()
    }

    func testFailScopeCreatesFailures() {
        let danger = githubWithFilesDSL()
        Jazzy.check(using: danger, "Tests/Fixtures", .fail, .all, [])
        
        XCTAssertEqual(danger.fails.count, 5)
        XCTAssertEqual(danger.messages.count, 0)
        XCTAssertEqual(danger.warnings.count, 0)
    }

    func testMessageScopeCreatesMessages() {
        let danger = githubWithFilesDSL()
        Jazzy.check(using: danger, "Tests/Fixtures", .message, .all, [])
        
        XCTAssertEqual(danger.fails.count, 0)
        XCTAssertEqual(danger.messages.count, 5)
        XCTAssertEqual(danger.warnings.count, 0)
    }

    func testWarningScopeCreatesWarnings() {
        let danger = githubWithFilesDSL()
        Jazzy.check(using: danger, "Tests/Fixtures", .warn, .all, [])
        
        XCTAssertEqual(danger.fails.count, 0)
        XCTAssertEqual(danger.messages.count, 0)
        XCTAssertEqual(danger.warnings.count, 5)
    }

    func testCanFindUndocumentedSymbolsInModifiedFiles() {
        let danger = githubWithFilesDSL(created: ["/MyFile.swift"], fileMap: ["/MyFile.swift": "//  Created by Foobar"])
        let symbols = Jazzy.undocumentedSymbols(using: danger, "Tests/Fixtures", .modified, [])
        XCTAssertEqual(symbols.count, 1)
    }

    func testCanFindUndocumentedSymbolsInAllFiles() {
        let danger = githubWithFilesDSL(created: ["/MyFile.swift"], fileMap: ["/MyFile.swift": "//  Created by Foobar"])
        let symbols = Jazzy.undocumentedSymbols(using: danger, "Tests/Fixtures", .all, [])
        XCTAssertEqual(symbols.count, 5)
    }

    func testFailIfUndocumentedJsonCantBeLoaded() {
        let danger = githubWithFilesDSL()
        Jazzy.check(using: danger, "Tests/Foobar", .fail, .all, [])

        XCTAssertEqual(danger.fails.count, 1)
        XCTAssertEqual(danger.messages.count, 0)
        XCTAssertEqual(danger.warnings.count, 0)
        XCTAssertEqual(danger.fails.first?.message, "Couldn\'t load undocumented info for Jazzy docs at \"Tests/Foobar\"")
    }

    // func testIgnoresFilesListedInIgnore() {
    //     XCTFail("Not implemented yet")
    // }

    // func testTemplates() {
    //     XCTFail("Not implemented yet")
    // }

    // func testSwitchesInlineTemplate() {
    //     XCTFail("Not implemented yet")
    // }

    static var allTests = [
        ("testFailScopeCreatesFailures", testFailScopeCreatesFailures),
        ("testMessageScopeCreatesMessages", testMessageScopeCreatesMessages),
        ("testWarningScopeCreatesWarnings", testWarningScopeCreatesWarnings),
        ("testCanFindUndocumentedSymbolsInModifiedFiles", testCanFindUndocumentedSymbolsInModifiedFiles),
        ("testCanFindUndocumentedSymbolsInAllFiles", testCanFindUndocumentedSymbolsInAllFiles),
        ("testFailIfUndocumentedJsonCantBeLoaded", testFailIfUndocumentedJsonCantBeLoaded)
    ]
}
