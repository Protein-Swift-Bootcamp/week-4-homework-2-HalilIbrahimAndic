//
//  EarthquakeManager.swift
//  Earthquake Tracker
//
//  Created by Halil Ibrahim Andic on 1.01.2023.
//

//   let earthquake = try? JSONDecoder().decode(Earthquake.self, from: jsonData)

struct Earthquake: Codable {
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Codable {
    let type: String
    let properties: Properties
}

// MARK: - Properties
struct Properties: Codable {
    let url: String
    let title: String
}
