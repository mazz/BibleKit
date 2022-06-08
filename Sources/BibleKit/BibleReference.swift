//
//  BibleReference.swift
//  TheWord
//
//  Created by Michael on 2022-03-27.
//
// https://github.com/joshpetit/reference_parser

import Foundation

/// Base protocol for all reference objects.
internal protocol BibleReference {
    /// The representation of the reference.
    var reference: String? { get set }

    /// The full book name of the reference.
    ///
    /// Can be an invalid book reference, always.
    /// check [isValid] to verify the reference's
    /// authenticity.
    var book: String { get set }

    /// The different reference formats for book names.
    /// Access values by using getters.
    var _bookNames: [String:String] { get set }

    /// The book number for the passed in reference book.
    ///
    /// `nil` if the book name is null or invalid.
    var bookNumber: Int? { get set }

    /// The type of reference.
    var referenceType: ReferenceType? { get set }

    /// Whether the reference is in the bible.
    var isValid: Bool { get set }

    /// Returns [BibleReference.reference]
    func toString() -> String

    /// The title cased representation for this reference's book.
    //  String? get osisBook => _bookNames['osis'];
    func osisBook() -> String?

    /// The uppercased paratext abbreviation for this reference's book.
    //  String? get abbrBook => _bookNames['abbr'];
    func abbrBook() -> String?

    /// The shortest standard abbreviation for this reference's book.
    //  String? get shortBook => _bookNames['short'];
    func shortBook() -> String?

    /// The title cased representation for this reference.
    //  String? get osisReference => _bookNames['osis'];
    func osisReference() -> String?

    /// The uppercased paratext abbreviation for this reference.
    //  String? get abbrReference => _bookNames['abbr'];
    func abbrReference() -> String?

    /// The shortest standard abbreviation for this reference.
    //  String? get shortReference => _bookNames['short'];
    func shortReference() -> String?
}

