//: Playground - noun: a place where people can play

import Foundation

typealias CacheKey = String

class Cacheable {
	func key() -> CacheKey {
		fatalError("Please override this function")
	}
	
	func merge(other: Cacheable) {
		fatalError("Please override this function")
	}
}

class CacheStore<CacheableValue: Cacheable> {
	var cache = [CacheKey:CacheableValue]()
	
	func save(value: CacheableValue) {
		if let exist = cache[value.key()] {
			exist.merge(other: value)
			cache[value.key()] = exist
			return
		}
		
		cache[value.key()] = value
	}
	
	func load(cacheable: CacheableValue) -> CacheableValue? {
		return cache[cacheable.key()]
	}
}

class Car: Cacheable {
	var id: String
	init (id: String) {
		self.id = id
	}
}

class FuelCar: Car {
	var fuelGallon: Int
	init(id: String, fuelGallon: Int = 0) {
		self.fuelGallon = fuelGallon
		super.init(id: id)
	}
	
	override func key() -> CacheKey {
		return id
	}
	
	override func merge(other: Cacheable) {
		guard let fuelCar = other as? FuelCar else {
			return
		}

		self.fuelGallon = fuelCar.fuelGallon
	}
}

func print(cacheable: FuelCar,store: CacheStore<FuelCar>) {
	print("fuelGallon: \(store.load(cacheable: cacheable)!.fuelGallon)")
}

var fuelCarCache = CacheStore<FuelCar>()
var car1 = FuelCar(id: "car1", fuelGallon: 0)
fuelCarCache.save(value: car1)

print(cacheable: car1, store: fuelCarCache)
// print: 0

car1.fuelGallon = 10

print(cacheable: car1, store: fuelCarCache)
// print: 10

fuelCarCache.save(value: car1)

print(cacheable: car1, store: fuelCarCache)
// print: 10

