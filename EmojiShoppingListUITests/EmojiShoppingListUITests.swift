//
//  EmojiShoppingListUITests.swift
//  EmojiShoppingListUITests
//
//  Created by Wouter Wisse on 17/05/2022.
//

import XCTest

class EmojiShoppingListUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
