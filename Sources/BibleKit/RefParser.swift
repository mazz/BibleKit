//
//  BibleReferenceParser.swift
//  TheWord
//
//  Created by Michael on 2022-06-06.
//

import Foundation

public class RefParser {}

extension RefParser {
    public static func parseReferences(_ stringReference: String) -> [Reference] {
        // make fullRegex for book, chapter, verse start and verse end
        if let regex = RefParser.fullRegex() {
            let range = NSRange(location: 0, length: stringReference.utf16.count)
            let matches = regex.matches(in: stringReference, options: [], range: range)

            if matches.count > 0 {
                // somewhere at least one match so find all match Reference items
                return RefParser.referencesFromMatches(matches: matches, stringReference: stringReference, range: range)
            } else {
                // nothing matched
                return []
            }
        }
        return []
    }

    static func referencesFromMatches(matches: [NSTextCheckingResult], stringReference: String, range: NSRange) -> [Reference] {
        var books: [[String]] = []

        for match in matches {
            var bookMatch: [String] = []
//            print("match: \(match)")
            for rangeIndex in 0..<match.numberOfRanges {
                let matchRange = match.range(at: rangeIndex)

                // Extract the substring matching the capture group
                if let substringRange = Range(matchRange, in: stringReference) {
//                    print("substringRange: \(substringRange)")
                    let capture = String(stringReference[substringRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                    bookMatch.append(capture)
                }
            }
            books.append(bookMatch)
        }

        print("books matched: \(books)")

        var resultReferences: [Reference] = []

        for bookReference in books {
            print("bookReference: \(bookReference)")
            // book name only i.e. ["genesis", "genesis"]
            if bookReference.count == 2 && bookReference[0] == bookReference[1] {
                resultReferences.append(Reference(book: bookReference[1], startChapter: nil, startVerse: nil, endChapter: nil, endVerse: nil))
            }
            // book with chapter only i.e. ["Judges 19", "Judges", "19"]
            else if bookReference.count == 3 {
                resultReferences.append(Reference(book: bookReference[1], startChapter: Int(bookReference[2]), startVerse: nil, endChapter: nil, endVerse: nil))

            }
            // book with chapter and verse i.e. ["Jn 3:16", "Jn", "3", "16"]
            // also covers chapter-only edge case where user enters `James 1 - 2` i.e. ["James 1 - 2", "James", "1", "2"]
            else if bookReference.count == 4 {
                // chapter-only reference -- also covers `em-dash` case
                if (bookReference[0].contains("-") || // normal dash
                    bookReference[0].contains("—")) && // em-dash
                    !bookReference[0].contains(":") {
                    resultReferences.append(Reference(book: bookReference[1], startChapter: Int(bookReference[2]), startVerse: nil, endChapter: Int(bookReference[3]), endVerse: nil))
                } else {
                    // book with chapter and verse i.e. ["Jn 3:16", "Jn", "3", "16"]
                    resultReferences.append(Reference(book: bookReference[1], startChapter: Int(bookReference[2]), startVerse: Int(bookReference[3]), endChapter: nil, endVerse: nil))
                }
            }
            // book with chapter and verse and range i.e. ["Jn 3:16-18", "Jn", "3", "16", "18"]
            else if bookReference.count == 5 {
                resultReferences.append(Reference(book: bookReference[1], startChapter: Int(bookReference[2]), startVerse: Int(bookReference[3]), endChapter: nil, endVerse: Int(bookReference[4])))
            }
            // A reference that spans multiple chapters. i.e. ["John 3:16-4:3", "John", "3", "16", "4", "3"]
            else if bookReference.count == 6 {
                resultReferences.append(Reference(book: bookReference[1], startChapter: Int(bookReference[2]), startVerse: Int(bookReference[3]), endChapter: Int(bookReference[4]), endVerse: Int(bookReference[5])))
            }
        }
        return resultReferences
    }

    static func fullRegex() -> NSRegularExpression? {
        var allBookNames: [String] = []
        BibleData.bookNames.forEach { allBookNames.append(contentsOf: $0) }
        allBookNames.append(contentsOf: BibleData.variants.keys)
        let regBooks = allBookNames.joined(separator: "\\b|\\b")

        if let expression = try? NSRegularExpression(pattern: "(\\b\(regBooks)\\b) *(\\d+)?[ :.]*(\\d+)?[— -]*(\\d+)?[ :.]*(\\d+)?", options: .caseInsensitive) {
            return expression
        } else {
            return nil
        }
    }
}
