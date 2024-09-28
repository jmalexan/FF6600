//
//  HackeryTests.swift
//  HackeryTests
//
//  Created by Jonathan Alexander on 9/14/24.
//

import Testing
@testable import Hackery

@Test func contentParsing() {
    let result = parseContent("this is a test<p>this text <em>will be</em> <i>emphasized</i><p>isn&#39;t this fun?<p>here is a link to <a href=\"https://www.google.com\" rel=\"nofollow\">Google</a>")
    #expect(result == "this is a test\nthis text *will be* *emphasized*\nisn't this fun?\nhere is a link to [Google](https://www.google.com)")
}
