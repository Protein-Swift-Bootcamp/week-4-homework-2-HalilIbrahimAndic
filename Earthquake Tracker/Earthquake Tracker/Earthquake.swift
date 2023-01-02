//
//  EarthquakeManager.swift
//  Earthquake Tracker
//
//  Created by Halil Ibrahim Andic on 1.01.2023.
//
import Foundation

struct Earthquake: Decodable {
    let features: [Feature]
}

// MARK: - Feature
struct Feature: Decodable {
    let properties: Properties
}

// MARK: - Properties
struct Properties: Decodable {
    let url: String
    let title: String
}

