//: [Previous](@previous)

import Foundation

protocol HasId {
	var id: String { get }
}
protocol HasCategoryId {
	var id: String { get }
}

struct Book: HasId, HasCategoryId {
	var id: String
}

extension CustomDebugStringConvertible where Self: HasId {
    var debugDescription: String {
        return "hasId: \(id)"
    }
}

extension CustomDebugStringConvertible where Self: HasCategoryId {
	var debugDescription: String {
		return "hasCategiryId: \(id)"
	}
}

// If you make comment below, you can get any compile errors.
extension CustomDebugStringConvertible where Self == Book {
	var debugDescription: String {
		return "hasId: \(id), hasCategoryId: \(id)"
	}
}

extension Book: CustomDebugStringConvertible {}

func printId(hasId: HasId) {
    debugPrint(hasId)
}

func printCategoryId(hasCategoryId: HasCategoryId) {
    debugPrint(hasCategoryId)
}

let book = Book(id: "isbn-9784798142494")
printId(hasId: book) // hasId: isbn-9784798142494, hasCategoryId: isbn-9784798142494
printCategoryId(hasCategoryId: book) // hasId: isbn-9784798142494, hasCategoryId: isbn-9784798142494
debugPrint(book) // hasId: isbn-9784798142494, hasCategoryId: isbn-9784798142494
