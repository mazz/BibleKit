//
//  TheWordTests.swift
//  TheWordTests
//
//  Created by Michael on 2022-03-18.
//

import XCTest
@testable import BibleKit

class BibleKit_ReferenceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRetrievingSubdividedReferences() throws {

        let chapter = Chapter(book: "Genesis", chapterNumber: 2)
        var verses = chapter.verses
        XCTAssert(verses?.count == 25)

        verses = chapter.verses
        XCTAssert(verses?.count == 25, "Ensures verses are cached")

        let book = Reference(book: "Genesis")
        var chapters = book.chapters
        XCTAssert(chapters?.count == 50)
        chapters = book.chapters
        XCTAssert(chapters?.count == 50, "Ensures chapters are cached")

        verses = book.verses
        XCTAssert(verses?.count == 1533)

        let range = Reference(book: "Genesis", startChapter: 2, startVerse: 3, endChapter: 4, endVerse: 5)

        verses = range.verses
        XCTAssert(verses?.count == 52)

        let verse = Reference(book: "Genesis", startChapter: 2, startVerse: 2)
        verses = verse.verses
        XCTAssert(verses?.count == 1)

    }

    func testRedirectiveConstructors() throws {
        let chapter = Reference(book: "Genesis", startChapter: 2)
        XCTAssert(chapter.reference == "Genesis 2")
        XCTAssert(chapter.referenceType == ReferenceType.chapter)

        let verse = Reference(book: "Genesis", startChapter: 2, startVerse: 2)
        XCTAssert(verse.reference == "Genesis 2:2")
        XCTAssert(verse.referenceType == ReferenceType.verse)

        let chapterRange = Reference(book: "Genesis", startChapter: 2, endChapter: 3)
        XCTAssert(chapterRange.reference == "Genesis 2-3")
        XCTAssert(chapterRange.referenceType == ReferenceType.chapterRange)

        let verseRange = Reference(book: "Genesis", startChapter: 2, startVerse: 3, endVerse: 4)
        XCTAssert(verseRange.reference == "Genesis 2:3-4")
        XCTAssert(verseRange.referenceType == ReferenceType.verseRange)

    }

}
