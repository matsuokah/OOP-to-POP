//: Playground - noun: a place where people can play

import Foundation

protocol HasId {
	var id: String { get }
}

protocol Mergeable {
	func merge(other: Self) -> Self
}

typealias CacheKey = String

protocol KeyCreator {
	func key() -> CacheKey
}

protocol Cacheable : KeyCreator, Mergeable {}

extension Cacheable where Self: HasId {
	func key() -> CacheKey {
		return id
	}
}

struct CacheStore<CacheableValue: Cacheable> {
	var cache = [CacheKey:CacheableValue]()
	
	mutating func save(value: CacheableValue) {
		if let exist = cache[value.key()] {
			cache[value.key()] = exist.merge(other: value)
			return
		}
		
		cache[value.key()] = value
	}
	
	func load(keyCreator: KeyCreator) -> CacheableValue? {
		return cache[keyCreator.key()]
	}
}

protocol Car: HasId { }

struct FuelCar: Car {
	var id: String
	var fuelGallon: Int
}

extension FuelCar: Cacheable {
	func merge(other: FuelCar) -> FuelCar {
		return FuelCar(id: self.id, fuelGallon: other.fuelGallon)
	}
}

func print<Key: KeyCreator>(key: Key,store: CacheStore<FuelCar>) {
	print("fuelGallon: \(store.load(keyCreator: key)!.fuelGallon)")
}

var fuelCarCache = CacheStore<FuelCar>()
var car1 = FuelCar(id: "car1", fuelGallon: 0)
fuelCarCache.save(value: car1)

print(key: car1, store: fuelCarCache)
// print: 0

car1.fuelGallon = 10

print(key: car1, store: fuelCarCache)
// print: 0

fuelCarCache.save(value: car1)
car1 = fuelCarCache.load(keyCreator: car1)!

print(key: car1, store: fuelCarCache)
// print: 10
