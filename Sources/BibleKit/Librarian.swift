//
//  Librarian.swift
//  TheWord
//
//  Created by Michael on 2022-03-27.
//

import Foundation

/// A grouping of fields that parse strings and numbers
/// to create reference objects or return information
/// on certain bible properties.
///
/// Uses the [BibleData] class extensively.

extension Dictionary {
  func contains(key: Key) -> Bool {
    self[key] != nil
  }
}

public class Librarian {
  ///Returns the book number from a string.
    internal static func findBookNumber(book: String) -> Int? {
    let bookLower = book.lowercased();
    var val = BibleData.books[bookLower];
    if (val != nil) {
      return val;
    }
    val = BibleData.osisBooks[bookLower];
    if (val != nil) {
      return val;
    }
    val = BibleData.shortenedBooks[bookLower];
    if (val != nil) {
      return val;
    }
    return BibleData.variants[bookLower];
  }

  ///Validate that a book is in the bible, does not validate mispellings.
    internal static func checkBook(book: String) -> Bool {
        let bookLower = book.lowercased();
        return BibleData.books.contains(key: bookLower) ||
        BibleData.osisBooks.contains(key: bookLower) ||
        BibleData.shortenedBooks.contains(key: bookLower)
    }

  /// Returns the osis, abbr, name, and short versions of a book title.
    internal static func getBookNames(book: Any) -> [String: String] {
        var foundBook: Int?
        if (book is String) {
            if let book = book as? String {
                foundBook = findBookNumber(book: book);
            }
        }
        if (book is Int) {
            foundBook = book as? Int
        }
        if let foundBook = foundBook {
            let list = BibleData.bookNames[foundBook - 1];
            return [
                "osis": list[0],
                "abbr": list[1],
                "name": list[2],
                "short": list[3]
            ]
        } else {
            return [:]
        }
  }

  /// Gets the last verse number in a specified book or book or chapter.
    internal static func getLastVerseNumber(book: Any, chapter: Int? = nil) -> Int? {
        var foundBook: Int?

        if (book is String) {
            if let book = book as? String {
                foundBook = findBookNumber(book: book);
            }
        }

        var foundChapter: Int?
        if let foundBook = foundBook {
            if let chapter = chapter {
                foundChapter = chapter
            } else {
                foundChapter = BibleData.lastVerse[foundBook - 1].count;
            }

            if let foundChapter = foundChapter {
                if (BibleData.lastVerse[foundBook - 1].count < foundChapter || foundChapter < 1) {
                    return nil
                }
                return BibleData.lastVerse[foundBook - 1][foundChapter - 1];
            } else {
                return nil
            }
        } else {
            return nil
        }
  }

  /// Returns the number for the last chapter within a book.
    internal static func getLastChapterNumber(book: Any) -> Int? {
        var foundBook: Int?
        if (book is String) {
            if let book = book as? String {
                foundBook = findBookNumber(book: book);
            }
        }
        if let foundBook = foundBook {
            if (foundBook > BibleData.lastVerse.count) {
                return nil
            } else {
                return BibleData.lastVerse[foundBook - 1].count
            }
        } else {
            return nil
        }
    }

    /// Creates a [Verse] object for the last verse in a book or chapter.
    internal static func getLastVerse(book: Any, chapter: Int?) -> Verse? {

        var bookNumber: Int?

        if (book is Int) {
            bookNumber = book as? Int
        } else if (book is String) {
            if let book = book as? String {
                bookNumber = findBookNumber(book: book);
            }
        }

        let bookNames = getBookNames(book: book);
        let bookName = bookNames["name"];

        var bookChapter: Int?

        if let chapter = chapter {
            bookChapter = chapter
        } else {
            if let bookNumber = bookNumber {
                bookChapter = BibleData.lastVerse[bookNumber - 1].count
            }
        }

        if let bookNumber = bookNumber,
           let bookChapter = bookChapter,
            let bookName = bookName {
            if (BibleData.lastVerse[bookNumber - 1].count < bookChapter || bookChapter < 1) {
                return nil
            }

            let lastVerse = BibleData.lastVerse[bookNumber - 1][bookChapter - 1];

            return Verse(book: bookName, chapterNumber: bookChapter, verseNumber: lastVerse)
        } else {
            return nil
        }
    }

    //  /// Returns a [Chapter] object that corresponds to the
    //  /// last chapter within a book.
    internal static func getLastChapter(book: Any) -> Chapter? {
        var bookNumber: Int?

        if (book is Int) {
            bookNumber = book as? Int
        } else if (book is String) {
            if let book = book as? String {
                bookNumber = findBookNumber(book: book);
            }
        } else {
            return nil
        }

        if bookNumber == nil {
            return nil
        }

        if let bookNumber = bookNumber {
            if (BibleData.lastVerse.count < bookNumber) {
                return nil
            }

            if let book = book as? String {
                var mutBook: String = book
                let bookNames = getBookNames(book: book)

                if let bookName = bookNames["name"] {
                    mutBook = bookName
                }

                let bookChapter = BibleData.lastVerse[bookNumber - 1].count
                return Chapter(book: mutBook, chapterNumber: bookChapter)
            } else {
                return nil
            }
        } else {
            return nil
        }
      }

  /// Returns the [ReferenceType] based on the number of passed in arguments.
    internal static func identifyReferenceType(book: Any,
                                      startChapter: Int? = nil,
                                      startVerse: Int? = nil,
                                      endChapter: Int? = nil,
                                      endVerse: Int? = nil) -> ReferenceType? {
        if (startChapter == nil && endChapter == nil) {
            return ReferenceType.BOOK
        } else if startChapter != nil &&
                           endChapter != nil &&
                           startChapter != endChapter {
            return ReferenceType.CHAPTER_RANGE
        } else if startChapter != nil &&
                           (endChapter == nil || endChapter == startChapter) &&
                           startVerse == nil &&
                   endVerse == nil {
            return ReferenceType.CHAPTER;
        } else if (startVerse != nil && endVerse != nil) {
            return ReferenceType.VERSE_RANGE
        } else if (startVerse != nil) {
            return ReferenceType.VERSE
        }
    return nil
  }

    /// Verifies a reference based on which fields are left `null`
    /// or can be found within the bible.
    internal static func verifyReference(book: Any?,
                                startChapter: Int? = nil,
                                startVerse: Int? = nil,
                                endChapter: Int? = nil,
                                endVerse: Int? = nil) -> Bool {
//                                [int? startChapter, int? startVerse, endChapter, endVerse])

        var mutEndChapter: Int? = endChapter

        if (book == nil) {
            return false;
        }

        var foundBook: Int?

        if (book is String) {
            if let book = book as? String {
                foundBook = findBookNumber(book: book);
            }
        }

        if (book is Int) {
            foundBook = book as? Int
        }

        if let foundBook = foundBook {
            if (!(foundBook > 0 && BibleData.lastVerse.count >= foundBook)) {
                return false;
            }

            if (startChapter != nil) {
                if let startChapter = startChapter {
                    if (!(startChapter > 0 &&
                          BibleData.lastVerse[foundBook - 1].count >= startChapter)) {
                        return false;
                    }
                    if mutEndChapter != nil {
                        if let mutEndChapter = mutEndChapter {
                            if startChapter > mutEndChapter {
                                return false
                            }
                        }
                    }
                }
            } else if (mutEndChapter != nil || endVerse != nil) {
                return false;
            }

            if (startVerse != nil) {

                if let startVerse = startVerse {
                    if (!(startVerse > 0 &&
                          BibleData.lastVerse[foundBook - 1][startChapter! - 1] >= startVerse)) {
                        return false;
                    }
                }
                if endVerse != nil {
                    if let endVerse = endVerse {
                        if let startVerse = startVerse {
                            if startVerse > endVerse {
                                return false
                            }
                        }
                    }
                }
            }

            if (mutEndChapter != nil) {
                if let mutEndChapter = mutEndChapter {
                    if (!(BibleData.lastVerse[foundBook - 1].count >= mutEndChapter)) {
                        return false;
                    }
                }
            }

            if mutEndChapter != nil {
                // no-op
            } else {
                mutEndChapter = startChapter
            }

            if (endVerse != nil) {
                if let endVerse = endVerse {
                    if (mutEndChapter == nil) {
                        return false;
                    }
                    if let mutEndChapter = mutEndChapter {
                        if (!(endVerse > 0 && BibleData.lastVerse[foundBook - 1][mutEndChapter - 1] >= endVerse)) {
                            return false;
                        }
                    }

                    if (mutEndChapter == nil && startVerse == nil) {
                        return false;
                    }
                    if let startVerse = startVerse {
                        if  (endVerse < startVerse) {
                            return false;
                        }
                    }
                }

            }
        } else {
            return false
        }
        return true;
    }

    internal static func createReferenceString(book: String?,
                                      startChapter: Int? = nil,
                                      startVerse: Int? = nil,
                                      endChapter: Int? = nil,
                                      endVerse: Int? = nil) -> String? {

        guard book != nil else { return nil }
        var reference: String = ""
        if let book = book,
           let startChapter = startChapter {
            reference.append(contentsOf: book)
            reference.append(contentsOf: " \(startChapter)")

            if startVerse != nil {
                if let startVerse = startVerse {
                    reference.append(contentsOf: ":\(startVerse)")

                    if endChapter != nil && endChapter != startChapter {
                        if let endChapter = endChapter {
                            reference.append(contentsOf: " - \(endChapter)")
                        }

                        if let endVerse = endVerse {
                            reference.append(contentsOf: ":\(endVerse)")
                        } else {
                            if let lastVerseNumber = getLastVerseNumber(book: book, chapter: endChapter) {
                                reference.append(contentsOf: ":\(lastVerseNumber)")
                            }
                        }

                    } else if endVerse != nil && endVerse != startVerse {
                        if let endVerse = endVerse {
                            reference.append(contentsOf: "-\(endVerse)")
                        }
                    }
                }
            } else if endChapter != nil && endChapter != startChapter {
                if endVerse != nil {
                    if let endChapter = endChapter,
                        let endVerse = endVerse {
                        reference.append(contentsOf: ":1 - \(endChapter):\(endVerse)")
                    }
                } else {
                    if let endChapter = endChapter {
                        reference.append(contentsOf: "-\(endChapter)")
                    }
                }
            }
        }
        return (reference == "") ? nil : reference
    }
}
