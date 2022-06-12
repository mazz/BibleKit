//
//  VerseEnum.swift
//  TheWord
//
//  Created by Michael on 2022-03-27.
//

import Foundation

/// The kind of reference a [BibleReference] is.
public enum ReferenceType: String, Codable {
  /// A reference that contains a
  /// book, chapter, and single verse.
  ///
  /// Genesis 2:3 for example. Generally associated
  /// with the [Verse] class.
    case verse

  /// A reference that contains a
  /// book, chapter, and multiple verses within
  /// the same chapter.
  ///
  /// For example, Genesis 2:2-4 is a
  /// verse range but not Genesis 2:2 - 3:5,
  /// this is an example of a [CHAPTER_RANGE].
    case verseRange

  /// A reference that contains a
  /// book and a chapter.
  ///
  /// Genesis 2 is an example. Generally associated
  /// with the [Chapter] class.
    case chapter

  /// A reference that spans multiple chapters.
  ///
  /// Genesis 2-3 or Genesis 2:3 - 2:5 are examples
  /// of chapter ranges.
    case chapterRange

  /// A reference that contains
  /// only a book.
  ///
  /// Genesis for example.
    case book
}
