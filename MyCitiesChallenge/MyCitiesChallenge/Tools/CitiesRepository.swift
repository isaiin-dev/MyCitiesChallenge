//
//  CitiesRepository.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//

import Foundation

/// A repository responsible for loading and searching cities from the bundled JSON file.
class CitiesRepository {
    
    static let shared = CitiesRepository()
    
    // Background queue for loading and processing the JSON data.
    private let queue = DispatchQueue(label: "com.myCitiesChallenge.CitiesRepositoryQueue", qos: .userInitiated)
    
    // Cached array of cities after parsing and sorting.
    private var cities: [CityList.City] = []
    
    // Flag to ensure cities are loaded only once.
    private var isLoaded: Bool = false
    
    /// Key for storing favorite city IDs in UserDefaults.
    private let favoritesKey = "favoriteCityIDs"
    
    /// Loads the cities from the JSON file if they have not been loaded yet.
    func loadCitiesIfNeeded(completion: @escaping (Bool) -> Void) {
        guard !isLoaded else {
            completion(true)
            return
        }
        
        queue.async { [weak self] in
            guard let self = self else { return }
            if let path = Bundle.main.path(forResource: "cities", ofType: "json"),
               let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    // Decode the JSON array into CityList.City objects.
                    let decodedCities = try JSONDecoder().decode([CityList.City].self, from: data)
                    // Sort the cities alphabetically, case-insensitive.
                    self.cities = decodedCities.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    self.isLoaded = true
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } catch {
                    print("Error decoding cities JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } else {
                print("Error: cities.json not found in bundle")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    /// Searches for cities matching the given prefix using binary search.
    func searchCities(prefix: String) -> [CityList.City] {
        // If not loaded, return empty.
        guard isLoaded else { return [] }
        
        // If the search prefix is empty, return all cities.
        if prefix.isEmpty { return cities }
        
        let lowerPrefix = prefix.lowercased()
        let startIndex = cities.lowerBound(ofPrefix: lowerPrefix)
        let endIndex = cities.upperBound(ofPrefix: lowerPrefix)
        
        if startIndex < endIndex {
            return Array(cities[startIndex..<endIndex])
        } else {
            return []
        }
    }
    
    /// Returns a slice of cities for pagination.
    func fetchPage(pageSize: Int, offset: Int) -> [CityList.City] {
        guard isLoaded else { return [] }
        let endIndex = min(offset + pageSize, cities.count)
        if offset < endIndex {
            return Array(cities[offset..<endIndex])
        } else {
            return []
        }
    }
}

// MARK: - Binary Search Helpers for CityList.City Arrays

extension Array where Element == CityList.City {
    /// Returns the lower bound index for cities whose names start with the given prefix.
    func lowerBound(ofPrefix prefix: String) -> Int {
        var low = 0
        var high = count
        
        while low < high {
            let mid = (low + high) / 2
            let midValue = self[mid].name.lowercased()
            if midValue.hasPrefix(prefix) || midValue >= prefix {
                high = mid
            } else {
                low = mid + 1
            }
        }
        return low
    }
    
    /// Returns the upper bound index for cities whose names start with the given prefix.
    func upperBound(ofPrefix prefix: String) -> Int {
        var low = 0
        var high = count
        
        // Create a string that is just greater than any string with the given prefix.
        let nextPrefix = prefix + "\u{FFFF}"
        
        while low < high {
            let mid = (low + high) / 2
            let midValue = self[mid].name.lowercased()
            if midValue < nextPrefix {
                low = mid + 1
            } else {
                high = mid
            }
        }
        return low
    }
}

extension CitiesRepository {
    var loadedCities: [CityList.City] {
        return cities
    }
}

// MARK: Favorites Management
extension CitiesRepository {
    
    /// Retrieves the array of favorite city IDs from UserDefaults.
    private func getFavoriteIDs() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    /// Saves the provided array of favorite city IDs to UserDefaults.
    private func setFavoriteIDs(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
    
    /// Adds a city to favorites by storing its ID.
    func addFavorite(city: CityList.City) {
        var ids = getFavoriteIDs()
        if !ids.contains(city.id) {
            ids.append(city.id)
            setFavoriteIDs(ids)
        }
    }
    
    /// Removes a city from favorites by deleting its ID.
    func removeFavorite(city: CityList.City) {
        var ids = getFavoriteIDs()
        if let index = ids.firstIndex(of: city.id) {
            ids.remove(at: index)
            setFavoriteIDs(ids)
        }
    }
    
    /// Returns all favorite cities by filtering the loaded cities with stored favorite IDs.
    func getFavorites() -> [CityList.City] {
        let ids = getFavoriteIDs()
        return cities.filter { ids.contains($0.id) }
    }
    
    /// Checks if the given city is marked as a favorite.
    func isFavorite(city: CityList.City) -> Bool {
        return getFavoriteIDs().contains(city.id)
    }
    
    /// Removes all favorite city IDs from UserDefaults.
    func clearFavorites() {
        setFavoriteIDs([])
    }
}

