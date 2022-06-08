//
//  Reference.swift
//  TheWord
//
//  Created by Michael on 2022-06-06.
//

import Foundation

public class Reference: BibleReference {
    public var book: String
    var _bookNames: [String : String]
    public var bookNumber: Int?
    public var referenceType: ReferenceType?
    public var startChapter: Chapter
    public var endChapter: Chapter?
    public var startVerse: Verse
    public var endVerse: Verse?
    public var startVerseNumber: Int?
    public var endChapterNumber: Int?
    public var endVerseNumber: Int?
    public var isValid: Bool

    private var _chapters: [Chapter]?

    public var chapters: [Chapter]? {
        if _chapters != nil {
          return _chapters;
        }
        _chapters = []
        var mutChapters: [Chapter] = []

        if let endChapterNumber = self.endChapterNumber,
           let chapters = self._chapters {
            mutChapters = chapters
            for i in 1 ... endChapterNumber {
                mutChapters.append(Chapter(book: self.book, chapterNumber: i))
            }
        }
        _chapters = mutChapters
        return _chapters;
    }

    private var _verses: [Verse]?

    public var verses: [Verse]? {
        if _verses != nil {
          return _verses;
        }

        var mutVerses: [Verse] = []

        if let endChapterNumber = self.endChapterNumber {

            for i in self.startChapterNumber ... endChapterNumber {
                let start = i == startChapterNumber ? startVerseNumber : 1
                let end = i == endChapterNumber ? endVerseNumber : Librarian.getLastVerseNumber(book: self.book, chapter: i)

                if let start = start,
                    let end = end {
                    for j in start ... end {
                        mutVerses.append(Verse(book: self.book, chapterNumber: i, verseNumber: j))
                    }
                }
            }
        }
        _verses = mutVerses
        return _verses
    }


    public func toString() -> String {
        return reference!
    }

    public func osisBook() -> String? {
        _bookNames["osis"]
    }

    public func abbrBook() -> String? {
        _bookNames["abbr"]
    }

    public func shortBook() -> String? {
        _bookNames["short"]
    }

    public func osisReference() -> String? {
        return Librarian.createReferenceString(book: osisBook(),
                                               startChapter: startChapterNumber,
                                               startVerse: startVerseNumber,
                                               endChapter: endChapterNumber,
                                               endVerse: endVerseNumber
        )
    }

    public func abbrReference() -> String? {
        return Librarian.createReferenceString(book: abbrBook(),
                                               startChapter: startChapterNumber,
                                               startVerse: startVerseNumber,
                                               endChapter: endChapterNumber,
                                               endVerse: endVerseNumber
        )
    }

    public func shortReference() -> String? {
        return Librarian.createReferenceString(book: shortBook(),
                                               startChapter: startChapterNumber,
                                               startVerse: startVerseNumber,
                                               endChapter: endChapterNumber,
                                               endVerse: endVerseNumber
        )
    }

    public var reference: String?
    var startChapterNumber: Int = 0

    public init(book: String,
         startChapter: Int? = nil,
         startVerse: Int? = nil,
         endChapter: Int? = nil,
         endVerse: Int? = nil) {

        self._bookNames = Librarian.getBookNames(book: book)

        var fullBookName: String
        if let swapBook = _bookNames["name"] {
            fullBookName = swapBook
        } else {
            fullBookName = book
        }

        startChapterNumber = startChapter ?? 1
        
        if let startChapter = startChapter {
            self.startChapter = Chapter(book: fullBookName, chapterNumber: startChapter)
        } else {
            self.startChapter = Chapter(book: fullBookName, chapterNumber: 1)
        }
        
        self.startVerseNumber = startVerse ?? 1
        
        if let startVerse = startVerse {
            self.startVerse = Verse(book: fullBookName, chapterNumber: startChapter, verseNumber: startVerse)
        } else {
            self.startVerse = Verse(book: fullBookName, chapterNumber: 1, verseNumber: 1)
        }
        
        self.endChapterNumber = endChapter ?? startChapter ?? Librarian.getLastChapterNumber(book: fullBookName)
        
        if let endChapter = endChapter {
            self.endChapter = Chapter(book: fullBookName, chapterNumber: endChapter)
        } else {
            if let startChapter = startChapter {
                self.endChapter = Chapter(book: fullBookName, chapterNumber: startChapter)
            } else {
                self.endChapter = Librarian.getLastChapter(book: fullBookName)
            }
        }
        
        self.endVerseNumber = endVerse ?? startVerse ?? Librarian.getLastVerseNumber(book: fullBookName, chapter: endChapter)
        
        if let endVerse = endVerse {
            self.endVerse = Verse(book: fullBookName, chapterNumber: startChapter, verseNumber: endVerse)
            
        } else {
            if let startVerse = startVerse {
                self.endVerse = Verse(book: fullBookName, chapterNumber: startChapter, verseNumber: startVerse)
            } else {
                self.endVerse = Librarian.getLastVerse(book: fullBookName, chapter: startChapter)
            }
        }
        
        self.reference = Librarian.createReferenceString(book: fullBookName,
                                                         startChapter: startChapterNumber,
                                                         startVerse: startVerse,
                                                         endChapter: endChapter,
                                                         endVerse: endVerse
        )
        
        self.referenceType = Librarian.identifyReferenceType(book: fullBookName,
                                                             startChapter: startChapterNumber,
                                                             startVerse: startVerse,
                                                             endChapter: endChapter,
                                                             endVerse: endVerse
        )
        
        self.isValid = Librarian.verifyReference(book: fullBookName,
                                                 startChapter: startChapterNumber,
                                                 startVerse: startVerse,
                                                 endChapter: endChapter,
                                                 endVerse: endVerse
        )
        
        self.book = fullBookName
        

    }
}

public extension Reference {
    static func chapter(book: String, chapter: Int) -> Reference {
        return Reference(book: book,
                         startChapter: chapter,
                         startVerse: nil,
                         endChapter: nil,
                         endVerse: nil
        )
    }

    static func verse(book: String, chapter: Int, verse: Int) -> Reference {
        return Reference(book: book,
                         startChapter: chapter,
                         startVerse: verse,
                         endChapter: nil,
                         endVerse: nil
        )
    }

    /// Construct a [Reference] as a chapter range such as
    /// Genesis 2-3.
    static func chapterRange(book: String, startChapter: Int, endChapter: Int) -> Reference {
        return Reference(book: book,
                         startChapter: startChapter,
                         startVerse: nil,
                         endChapter: endChapter,
                         endVerse: nil
        )
    }

    /// Construct a [Reference] as a verse range such as
    /// Genesis 2:3-4.
    static func verseRange(book: String, chapter: Int, startVerse: Int, endVerse: Int) -> Reference {
        return Reference(book: book,
                         startChapter: chapter,
                         startVerse: startVerse,
                         endChapter: nil,
                         endVerse: endVerse
        )
    }

}
