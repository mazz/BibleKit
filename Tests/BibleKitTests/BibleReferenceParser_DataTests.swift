//
//  TheWordTests.swift
//  TheWordTests
//
//  Created by Michael on 2022-03-18.
//

import XCTest
@testable import BibleKit

class BibleReferenceParser_DataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRetrievesCorrectBookNumber() throws {
        let genesis = Librarian.findBookNumber(book: "genesis")
        XCTAssert(genesis == 1, "Genesis is the first book")

        let firstCor = Librarian.findBookNumber(book: "1cor")
        XCTAssert(firstCor == 46, "1cor is the 46th book")

        let psalms = Librarian.findBookNumber(book: "psalm")
        XCTAssert(psalms == 19, "Psalm(s) is the 19th book")
    }

    func testReturnsNilForNonexistentBooks() throws {
        let joseph = Librarian.findBookNumber(book: "joseph")
        XCTAssert(joseph == nil, "Joseph is not a book in the bible")
    }

    func testLibrarianChecksBookValidityCorrectly() throws {
        let joseph = Librarian.checkBook(book: "joseph")
        XCTAssert(joseph == false, "Joseph is an invalid book")

        let firstCor = Librarian.checkBook(book: "1cor")
        XCTAssert(firstCor == true, "1cor is a valid book")

        let genesis = Librarian.checkBook(book: "Genesis")
        XCTAssert(genesis == true, "Genesis is a valid book")

        let jn = Librarian.checkBook(book: "jn")
        XCTAssert(jn == true, "jn is a valid book")
    }

    func testLibrarianReturnsCorrectBookNames() throws {
        let genesisNames = Librarian.getBookNames(book: 1)
        XCTAssert(genesisNames["osis"] == "Gen")
        XCTAssert(genesisNames["abbr"] == "GEN")
        XCTAssert(genesisNames["name"] == "Genesis")
        XCTAssert(genesisNames["short"] == "Gn")

        let firstCor = Librarian.getBookNames(book: "1 Corinthians")
        XCTAssert(firstCor["osis"] == "1Cor")
        XCTAssert(firstCor["abbr"] == "1CO")
        XCTAssert(firstCor["name"] == "1 Corinthians")
        XCTAssert(firstCor["short"] == "1 Cor")

        let empty = Librarian.getBookNames(book: "")
        XCTAssert(empty.isEmpty)
    }

    func testLibrarianCorrectlyVerifiesVerses() throws {
        XCTAssert(Librarian.verifyReference(book: 1) == true, "First book should exist")
        XCTAssert(Librarian.verifyReference(book: 33) == true, "Middle book should exist")
        XCTAssert(Librarian.verifyReference(book: 66) == true, "Last book should exist")
        XCTAssert(Librarian.verifyReference(book: 67) == false, "67th book does not exist")
        XCTAssert(Librarian.verifyReference(book: -1) == false, "Negative books do not exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1) == true, "Book and chapter should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 8) == false, "Book and chapter should not exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, startVerse: 1) == true, "Book and chapter should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, endVerse: 16) == true, "Book, chapter, and ending verse should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, endVerse: 17) == false, "Verse should not exist")
        XCTAssert(Librarian.verifyReference(book: "John", startChapter: 1, startVerse: 1) == true, "String book references should work'")

        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, startVerse: 17, endChapter: nil, endVerse: 18) == false, "Verse should not exist")

        XCTAssert(Librarian.verifyReference(book: "John", startChapter: 1, startVerse: 1, endChapter: 1, endVerse: 2) == true, "String book references should work")
    }


    func testLibrarianCorrectlyFetchesLastVerseAndChapterNumbers() throws {
        XCTAssert(Librarian.getLastVerseNumber(book: "John") == 25)
        XCTAssert(Librarian.getLastChapterNumber(book: "John") == 21)
    }

    func testLibrarianCorrectlyCreatesReferenceType() throws {
        XCTAssert(Librarian.identifyReferenceType(book: "John") == ReferenceType.BOOK)
        XCTAssert(Librarian.identifyReferenceType(book: "John", startChapter: 1) == ReferenceType.CHAPTER)
        XCTAssert(Librarian.identifyReferenceType(book: "Joeseph", startChapter: 2, startVerse: 4) == ReferenceType.VERSE)
        XCTAssert(Librarian.identifyReferenceType(book: "Joeseph", startChapter: 2, startVerse: 4, endChapter: 5) == ReferenceType.CHAPTER_RANGE)
    }

    func testLibrarianCorrectlyCreatesLastVerseObjects() throws {
        let verseJohn = Librarian.getLastVerse(book: "John", chapter: nil)
        XCTAssert(verseJohn?.book == "John")
        XCTAssert(verseJohn?.chapterNumber == 21)
        XCTAssert(verseJohn?.verseNumber == 25)
        XCTAssert(verseJohn?.referenceType == ReferenceType.VERSE)

        let versePs = Librarian.getLastVerse(book: "Ps", chapter: nil)
        XCTAssert(versePs?.book == "Psalms")
        XCTAssert(versePs?.chapterNumber == 150)
        XCTAssert(versePs?.verseNumber == 6)
        XCTAssert(versePs?.referenceType == ReferenceType.VERSE)

        let verseGen2 = Librarian.getLastVerse(book: "Gen", chapter: 2)
        XCTAssert(verseGen2?.book == "Genesis")
        XCTAssert(verseGen2?.chapterNumber == 2)
        XCTAssert(verseGen2?.verseNumber == 25)
        XCTAssert(verseGen2?.referenceType == ReferenceType.VERSE)

    }

    func testLibrarianCorrectlyCreatesLastChapterObjects() throws {
        let chapterGen = Librarian.getLastChapter(book: "Gen")
        XCTAssert(chapterGen?.book == "Genesis")
        XCTAssert(chapterGen?.chapterNumber == 50)
        XCTAssert(chapterGen?.referenceType == ReferenceType.CHAPTER)
    }

    func testLibrarianCreatesCorrectReferenceStrings() throws {
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2) == "John 2")
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2, startVerse: 3) == "John 2:3")
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2, startVerse: 3, endChapter: 4) == "John 2:3 - 4:54")
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2, startVerse: 3, endChapter: 4, endVerse: 5) == "John 2:3 - 4:5")
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2, startVerse: nil, endChapter: 4, endVerse: 5) == "John 2:1 - 4:5")
        XCTAssert(Librarian.createReferenceString(book: "John", startChapter: 2, startVerse: nil, endChapter: 4) == "John 2-4")
    }

    func testLibrarianCorrectlyVerifiesReferences() throws {
        XCTAssert(Librarian.verifyReference(book: 1) == true, "First book should exist")
        XCTAssert(Librarian.verifyReference(book: 66) == true, "Last book should exist")
        XCTAssert(Librarian.verifyReference(book: 67) == false, "67th book does not exist")
        XCTAssert(Librarian.verifyReference(book: -1) == false, "Negative books do not exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1) == true, "Book and chapter should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: -1) == false, "Negative chapters do not exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 8) == false, "Book and chapter should not exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, startVerse: 1) == true, "Book, chapter, and verse should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, endVerse: 16) == true, "Book, chapter, and ending verse should exist")
        XCTAssert(Librarian.verifyReference(book: 33, startChapter: 1, startVerse: 17) == false, "Reference should not exist")
        XCTAssert(Librarian.verifyReference(book: "John", startChapter: 1, startVerse: 1) == true, "String book references should work")
        XCTAssert(Librarian.verifyReference(book: "John", startChapter: 1, startVerse: nil, endChapter: 1) == true, "Multi chapter references should work")
        XCTAssert(Librarian.verifyReference(book: "John", startChapter: nil, startVerse: nil, endChapter: nil, endVerse: 5) == false, "End verses require a starting verse or ending chapter")
        XCTAssert(Librarian.verifyReference(book: "John", startChapter: 1, startVerse: nil, endChapter: 2, endVerse: 5) == true, "Ending verse + chapter can have a starting chapter without a starting verse")
    }

}
