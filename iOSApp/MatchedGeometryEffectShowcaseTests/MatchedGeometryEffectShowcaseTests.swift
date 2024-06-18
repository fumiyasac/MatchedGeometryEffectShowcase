//
//  MatchedGeometryEffectShowcaseTests.swift
//  MatchedGeometryEffectShowcaseTests
//
//  Created by 酒井文也 on 2024/06/17.
//

import XCTest
import Testing

final class AllTests: XCTestCase {

    // MARK: - Function

    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
}
