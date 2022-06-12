//
//  TheWordTests.swift
//  TheWordTests
//
//  Created by Michael on 2022-03-18.
//

import XCTest
@testable import BibleKit

class BibleKit_ParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreationOfReferenceFromParser() throws {
        var ref = RefParser.parseReferences("John 3:16")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "John 3:16")
        XCTAssert(ref[0].book == "John")
        XCTAssert(ref[0].startChapterNumber == 3)
        XCTAssert(ref[0].startVerseNumber == 16)

        ref = RefParser.parseReferences("1john 3:16")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "1 John 3:16")
        XCTAssert(ref[0].book == "1 John")
        XCTAssert(ref[0].startChapterNumber == 3)
        XCTAssert(ref[0].startVerseNumber == 16)

        ref = RefParser.parseReferences("Jn 2:4")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "John 2:4")
        XCTAssert(ref[0].book == "John")
        XCTAssert(ref[0].startChapterNumber == 2)
        XCTAssert(ref[0].startVerseNumber == 4)
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("")
        XCTAssert(ref.count == 0)

        ref = RefParser.parseReferences("I love John 4:5-10")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "John 4:5-10")
        XCTAssert(ref[0].book == "John")
        XCTAssert(ref[0].startChapterNumber == 4)
        XCTAssert(ref[0].startVerseNumber == 5)
        XCTAssert(ref[0].endVerseNumber == 10)
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("This is not going to parse Matthew")
        XCTAssert(ref.count == 2)
        XCTAssert(ref[0].book == "Isaiah", "\"is\" is parsed first")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("Only jam should be parsed")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("Joe 2:5-10")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "Joel 2:5-10")
        XCTAssert(ref[0].book == "Joel")
        XCTAssert(ref[0].startChapterNumber == 2)
        XCTAssert(ref[0].startVerseNumber == 5)
        XCTAssert(ref[0].endVerseNumber == 10)
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("Joseph 5:10-11")
        XCTAssert(ref.count == 0)

        ref = RefParser.parseReferences("So what about James 1 - 2")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1-2")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].startChapterNumber == 1)
        XCTAssert(ref[0].endChapterNumber == 2)
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("James 1.2")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1:2")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("James 1.2 -  2")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1:2")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        // The ~em~ dash
        ref = RefParser.parseReferences("James 1—2")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1-2")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("James 1.2 -  2:4")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1:2 - 2:4")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("James 1 . 2 -  2 . 4")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "James 1:2 - 2:4")
        XCTAssert(ref[0].book == "James")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("Matthew 2:3-5 - 5:7")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "Matthew 2:3-5")
        XCTAssert(ref[0].book == "Matthew")
        XCTAssert(ref[0].isValid == true)

        ref = RefParser.parseReferences("genesis")
        XCTAssert(ref.count == 1)
        XCTAssert(ref[0].reference == "Genesis")
        XCTAssert(ref[0].book == "Genesis")
        XCTAssert(ref[0].referenceType == ReferenceType.book)
        XCTAssert(ref[0].isValid == true)

    }

    func testParsingAllReferences() throws {
        var refs = RefParser.parseReferences("I hope Matt 2:4 and James 5:1-5 get parsed")
        XCTAssert(refs.count == 2)

        let mat = refs[0]
        let jam = refs[1]

        XCTAssert(mat.book == "Matthew")
        XCTAssert(mat.startChapterNumber == 2)
        XCTAssert(mat.startVerseNumber == 4)
        XCTAssert(jam.book == "James")
        XCTAssert(jam.startChapterNumber == 5)
        XCTAssert(jam.startVerseNumber == 1)
        XCTAssert(jam.endVerseNumber == 5)

        refs = RefParser.parseReferences("is is still parsed")
        XCTAssert(refs.count == 2)

        refs = RefParser.parseReferences("This contains nothing")
        XCTAssert(refs.count == 0, "This string contains no references")
    }

    func testVerifyParatexts() throws {
        let refs = RefParser.parseReferences("Mat Jam PSA joh")
        for ref in refs {
            XCTAssert(ref.book.count > 3, "Paratexts should be parsed")
        }
    }
}
