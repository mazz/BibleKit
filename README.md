# BibleKit

This is a port of the Dart package https://github.com/joshpetit/reference_parser to Swift.

A Swift package that parses strings for bible references. You can parse single references or multiple references from a string in a variety of formats.

Really 99% of what you need to know will be found in 
[Parsing References](#parsing-references)
headers. But if you have more complicated needs this package can handle those!

<!-- toc -->
- [Usage](#usage)
  * [Parsing References](#parsing-references)
  * [Objects and References](#objects-and-references)
    + [Reference](#reference)
    + [Verses](#verses)
    + [Chapters](#chapters)
    + [Books](#books)
  * [Constructing References](#constructing-references)
    + [Invalid References](#invalid-references)
<!-- tocstop -->

# Usage

to include this in your Swift application:
```swift
import BibleKit
```

## Parsing References
use the `parseReference` function to retrieve a single reference:

```swift
let refs: [Reference] = RefParser.parseReferences("I like Mat 2:4-10 and 1john 3:16")
```

This will return two reference objects, one describing "Matthew 2:4-10" and the other "1 John 3:16"

**Note**: The word 'is' will be parsed as the book of Isaiah.

## Objects and References

### Reference
Reference objects are the broadest kind of reference.
You can directly construct one by following this format:

```swift
let range = Reference(book: "Genesis", startChapter: 2, startVerse: 3, endChapter: 4, endVerse: 5)
```

Their most important fields are these:
```swift
ref.reference // The string representation (osisReference, shortReference, and abbr also available)
ref.startVerseNumber
ref.endVerseNumber
ref.startChapterNumber
ref.endChapterNumber
ref.referenceType // VERSE, CHAPTER, VERSE_RANGE, CHAPTER_RANGE
```
Based on what is passed in, the constructor will figure out
certain fields. For example, if you were to construct `Reference('James')`
the last chapter and verse numbers in James will be initialized accordingly.

There are many other fields that may prove useful such as 
ones that subdivid the reference, look [here](#other-fun stuff)

-------

### Verses

`Reference` objects have a `startVerse` and `endVerse` field
that return objects of the Verse type.
```swift
let genbook: Reference = Reference(book: "Genesis")
let firstVerse = genbook.startVerse;

// same as firstVerse above
let first: Verse = Verse(book: "Genesis", chapterNumber: 1, verseNumber: 1)
```

You can also construct `Reference`s that 'act' like
verses by using the named constructor
```swift
let gen11 = Reference.verse(book: "Genesis", chapter: 1, verse: 1)
```

------

### Chapters
```swift
let james5 = RefParser.parseReferences("James 5 is a chapter").first
```
The `james5` object now holds a `Reference` to "James 5". Despite this, startVerseNumber and endVerseNumber are initialized to the first and last verses in James 5. 
```swift
james5.startVerseNumber // 1
james5.endVerseNumber // 20
james5.referenceType // ReferenceType.CHAPTER
```

The Reference object also has start/end chapter fields
```dart
let james510 = RefParser.parseReferences("James 5-10 is cool").first
james510.startChapterNumber // 5
james510.endChapterNumber // 10
```

Just like verses you can create chapter objects:

```swift
let john1 = Chapter(book: "John", chapterNumber: 1)
```
------

### Books
```swift
let ecc = RefParser.parseReferences("Ecclesiastes is hard to spell").first
ecc.startChapterNumber // 1
ecc.endChapterNumber // 12
ecc.ReferenceType // ReferenceType.BOOK
```
Books don't have their own class, they're the equivalent of
a `Reference` object.

## Constructing References

### Verses
```swift
let matt24 = Reference(book: "Mat", startChapter: 2, startVerse: 4)
let matt24 = Reference.verse(book: "Mat", chapter: 2, verse: 4)
let matt24: Verse = Verse(book: "Matt", chapterNumber: 2, verseNumber: 4)
```
Note that the `verse` object has different fields than a
`Reference` object. Check the API.

### Verse Ranges
```swift
let matt2410 = Reference(book: "Mat", startChapter: 2, startVerse: 4, endChapter: nil, endVerse: 10)
let matt2410 = Reference.verseRange(book: "Mat", chapter: 2, startVerse: 4, endVerse: 10)
```
These are equivalents that create a reference to 'Matthew 2:4-10'.

The same constructors and classes apply for chapters.

### Invalid References
All references have an `isValid` field that says whether this reference
is within the bible.

```swift
let mcd = Reference(book: "McDonald", startChapter: 2, startVerse: 4, endChapter: 10)
print(mcd.isValid) // false, as far as I know at least.
```
**Notice that the other fields are still initialized!!** So if needed, make
sure to check that a reference is valid before using it.
```swift
mcd.reference // "McDonald 2:4-10"
mcd.book // "McDonald"
mcd.startVerseNumber // 4
mcd.osisBook // nil, and so will be other formats.
```

The same logic applies to chapters and verse numbers.
```swift
let jude2 = Reference(book: "Jude", startChapter: 2, startVerse: 10)
jude2.isValid // false (Jude only has one chapter)
```
