//
//  CitiesRepository.swift
//  MyCitiesChallenge
//
//  Created by Alejandro isai Acosta Martinez on 05/03/25.
//

import Foundation

/// Protocol that defines the methods for loading and retrieving cities.
protocol CitiesRepositoryProtocol {
    /// Loads the cities from the JSON file if they haven't been loaded already.
    /// - Parameter completion: A closure that is called on the main thread with a Bool indicating success.
    func loadCitiesIfNeeded(completion: @escaping (Bool) -> Void)
    
    /// Searches for cities whose name starts with the given prefix.
    /// - Parameter prefix: The prefix string to search.
    /// - Returns: An array of matching CityList.City objects.
    func searchCities(prefix: String) -> [CityList.City]
    
    /// Fetches a page of cities from the loaded dataset.
    /// - Parameters:
    ///   - pageSize: The number of cities per page.
    ///   - offset: The starting index of the page.
    /// - Returns: An array of CityList.City objects for the requested page.
    func fetchPage(pageSize: Int, offset: Int) -> [CityList.City]
}

/// A repository responsible for loading and searching cities from the bundled JSON file.
class CitiesRepository: CitiesRepositoryProtocol {
    
    // Background queue for loading and processing the JSON data.
    private let queue = DispatchQueue(label: "com.myCitiesChallenge.CitiesRepositoryQueue", qos: .userInitiated)
    
    // Cached array of cities after parsing and sorting.
    private var cities: [CityList.City] = []
    
    // Flag to ensure cities are loaded only once.
    private var isLoaded: Bool = false
    
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
