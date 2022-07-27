/// A bible reference that contains the book, chapter, and a single verse number.
///
/// When instantiated by the [Reference] class, this object usually refers to the
/// reference object's first or last verse within that reference.

public class Verse: BibleReference, CustomStringConvertible {
    public var description: String {
           if let chapterNumber = chapterNumber,
           let reference = reference {
            return "<\(type(of: self)): \"\(reference)\", book: \(book), chapter: \(chapterNumber), verse: \(verseNumber), isValid: \(isValid) \(Unmanaged.passUnretained(self).toOpaque())>"
        } else {
            return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }

    public var book: String
    var _bookNames: [String : String]
    public var bookNumber: Int?
    public var referenceType: ReferenceType?
    /// The book, chapter, and verse number.
    ///
    /// The full book name of the reference in Book chapter:verse format
    public var reference: String?
    /// The chapter number this verse is within.
    public var chapterNumber: Int?
    /// The verse number this verse refers to within a chapter.
    public var verseNumber: Int
    /// [ReferenceType.VERSE].
    /// Whether this verse is found within the bible.
    public var isValid: Bool
    public init(book: String, chapterNumber: Int?, verseNumber: Int) {
        self.book = book
        self._bookNames = Librarian.getBookNames(book: book)
        self.bookNumber = Librarian.findBookNumber(book: book)
        self.referenceType = ReferenceType.verse
        self.reference = Librarian.createReferenceString(book: book, startChapter: chapterNumber, startVerse: verseNumber)
        self.chapterNumber = chapterNumber
        self.verseNumber = verseNumber
        self.isValid = Librarian.verifyReference(book: book, startChapter: chapterNumber, startVerse: verseNumber)
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

    /// The title cased osis representation for this verse in
    /// Book chapter:verse format.

    public func osisReference() -> String? {
        return Librarian.createReferenceString(book: osisBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }

    /// The uppercased paratext abbreviation for this verse.
    /// in BOOKchapter:verse format.

    public func abbrReference() -> String? {
        Librarian.createReferenceString(book: abbrBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }

    /// The shortest standard abbreviation for this verse in
    /// Book chapter:verse format.
    public func shortReference() -> String? {
        Librarian.createReferenceString(book: shortBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }
}

public class Chapter: BibleReference, CustomStringConvertible {
    public var description: String {
        if let referenceType = referenceType,
           let endVerseNumber = endVerseNumber,
           let reference = reference {
            return "<\(type(of: self)): \"\(reference)\", book: \(book), chapterNumber: \(chapterNumber), startVerse: \(startVerseNumber), endVerse: \(endVerseNumber), isValid: \(isValid) \(Unmanaged.passUnretained(self).toOpaque())>"
        } else {
            return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
        }
    }

    var _bookNames: [String : String]

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
        return Librarian.createReferenceString(book: osisBook(), startChapter: chapterNumber)
    }

    public func abbrReference() -> String? {
        return Librarian.createReferenceString(book: abbrBook(), startChapter: chapterNumber)
    }

    public func shortReference() -> String? {
        return Librarian.createReferenceString(book: shortBook(), startChapter: chapterNumber)
    }

    public var bookNumber: Int?
    public var book: String
    public var referenceType: ReferenceType?
    /// The book, chapter, and verse number.
    ///
    /// The full book name of the reference in Book chapter:verse format
    public var reference: String?
    /// The chapter number this verse is within.
    public var chapterNumber: Int
    /// The first verse within this chapter.
    public var startVerseNumber: Int
    /// The first verse in this chapter represented
    /// by a [Verse] object.
    public var startVerse: Verse
    /// The last verse in this chapter represented
    /// by a [Verse] object.
    public var endVerse: Verse?
    /// The last verse within this chapter.
    public var endVerseNumber: Int?

    private var _verses: [Verse]?

    public var verses: [Verse]? {
        if _verses != nil {
            return _verses;
        }
        _verses = []
        var mutVerses: [Verse] = []
        if let endVerseNumber = self.endVerseNumber,
           let verses = self._verses {
            mutVerses = verses
            for i in 1 ... endVerseNumber {
                mutVerses.append(Verse(book: self.book, chapterNumber: self.chapterNumber, verseNumber: i))
            }
        }
        _verses = mutVerses
        return _verses;
    }
    /// The numerated chapter that this reference is within the book.
    public var isValid: Bool

    public init(book: String, chapterNumber: Int) {
        self.book = book
        self._bookNames = Librarian.getBookNames(book: book)
        self.chapterNumber = chapterNumber
        self.referenceType = ReferenceType.chapter
        self.reference = Librarian.createReferenceString(book: book, startChapter: chapterNumber)
        self.startVerseNumber = 1
        self.startVerse = Verse(book: book, chapterNumber: chapterNumber, verseNumber: 1)
        self.endVerse = Librarian.getLastVerse(book: book, chapter: chapterNumber)
        self.endVerseNumber = Librarian.getLastVerseNumber(book: book, chapter: chapterNumber)
        self.isValid = Librarian.verifyReference(book: book, startChapter: chapterNumber)
    }
}
