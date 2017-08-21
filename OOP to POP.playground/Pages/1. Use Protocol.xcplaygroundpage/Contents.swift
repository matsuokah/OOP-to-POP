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

protocol Cacheable: KeyCreator, Mergeable { }

class CacheStore<CacheableValue: Cacheable> {
	var cache = [CacheKey:CacheableValue]()
	
	func save(value: CacheableValue) {
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

class Car: HasId {
	var id: String
	init (id: String) {
		self.id = id
	}
}

class FuelCar: Car, Cacheable {
	var fuelGallon: Int
	init(id: String, fuelGallon: Int = 0) {
		self.fuelGallon = fuelGallon
		super.init(id: id)
	}

	func key() -> CacheKey {
		return id
	}

	func merge(other: FuelCar) -> Self {
		if self.id == other.id {
			self.fuelGallon = other.fuelGallon
		}
		return self
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
// print: 10

fuelCarCache.save(value: car1)

print(key: car1, store: fuelCarCache)
// print: 10
