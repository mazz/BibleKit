public struct BibleKit {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

/// A bible reference that contains the book, chapter, and a single verse number.
///
/// When instantiated by the [Reference] class, this object usually refers to the
/// reference object's first or last verse within that reference.

public class Verse: BibleReference {
    var book: String
    var _bookNames: [String : String]
    var bookNumber: Int?
    var referenceType: ReferenceType?
    /// The book, chapter, and verse number.
    ///
    /// The full book name of the reference in Book chapter:verse format
    var reference: String?
    /// The chapter number this verse is within.
    var chapterNumber: Int?
    /// The verse number this verse refers to within a chapter.
    var verseNumber: Int
    /// [ReferenceType.VERSE].
    /// Whether this verse is found within the bible.
    var isValid: Bool
    init(book: String, chapterNumber: Int?, verseNumber: Int) {
        self.book = book
        self._bookNames = Librarian.getBookNames(book: book)
        self.bookNumber = Librarian.findBookNumber(book: book)
        self.referenceType = ReferenceType.VERSE
        self.reference = Librarian.createReferenceString(book: book, startChapter: chapterNumber, startVerse: verseNumber)
        self.chapterNumber = chapterNumber
        self.verseNumber = verseNumber
        self.isValid = Librarian.verifyReference(book: book, startChapter: chapterNumber, startVerse: verseNumber)
    }

    func toString() -> String {
        return reference!
    }

    func osisBook() -> String? {
        _bookNames["osis"]
    }

    func abbrBook() -> String? {
        _bookNames["abbr"]
    }

    func shortBook() -> String? {
        _bookNames["short"]
    }

    /// The title cased osis representation for this verse in
    /// Book chapter:verse format.

    func osisReference() -> String? {
        return Librarian.createReferenceString(book: osisBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }

    /// The uppercased paratext abbreviation for this verse.
    /// in BOOKchapter:verse format.

    func abbrReference() -> String? {
        Librarian.createReferenceString(book: abbrBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }

    /// The shortest standard abbreviation for this verse in
    /// Book chapter:verse format.
    func shortReference() -> String? {
        Librarian.createReferenceString(book: shortBook(), startChapter: chapterNumber, startVerse: verseNumber);
    }
}

public class Chapter: BibleReference {
    var _bookNames: [String : String]

    func toString() -> String {
        return reference!
    }

    func osisBook() -> String? {
        _bookNames["osis"]
    }

    func abbrBook() -> String? {
        _bookNames["abbr"]
    }

    func shortBook() -> String? {
        _bookNames["short"]
    }

    func osisReference() -> String? {
        return Librarian.createReferenceString(book: osisBook(), startChapter: chapterNumber)
    }

    func abbrReference() -> String? {
        return Librarian.createReferenceString(book: abbrBook(), startChapter: chapterNumber)
    }

    func shortReference() -> String? {
        return Librarian.createReferenceString(book: shortBook(), startChapter: chapterNumber)
    }

    var bookNumber: Int?
    var book: String
    var referenceType: ReferenceType?
    /// The book, chapter, and verse number.
    ///
    /// The full book name of the reference in Book chapter:verse format
    var reference: String?
    /// The chapter number this verse is within.
    var chapterNumber: Int
    /// The first verse within this chapter.
    var startVerseNumber: Int
    /// The first verse in this chapter represented
    /// by a [Verse] object.
    var startVerse: Verse
    /// The last verse in this chapter represented
    /// by a [Verse] object.
    var endVerse: Verse?
    /// The last verse within this chapter.
    var endVerseNumber: Int?

    private var _verses: [Verse]?

    var verses: [Verse]? {
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
    var isValid: Bool

    init(book: String, chapterNumber: Int) {
        self.book = book
        self._bookNames = Librarian.getBookNames(book: book)
        self.chapterNumber = chapterNumber
        self.referenceType = ReferenceType.CHAPTER
        self.reference = Librarian.createReferenceString(book: book, startChapter: chapterNumber)
        self.startVerseNumber = 1
        self.startVerse = Verse(book: book, chapterNumber: chapterNumber, verseNumber: 1)
        self.endVerse = Librarian.getLastVerse(book: book, chapter: chapterNumber)
        self.endVerseNumber = Librarian.getLastVerseNumber(book: book, chapter: chapterNumber)
        self.isValid = Librarian.verifyReference(book: book, startChapter: chapterNumber)
    }
}
