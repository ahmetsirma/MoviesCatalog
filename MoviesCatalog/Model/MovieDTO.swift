//
//  Movie.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation

public struct MovieDTOModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case title = "title"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    public let title: String?
    public let overview: String?
    public let posterPath: String?
    public let releaseDate: Date?
    public let voteAverage: Double?
    public let voteCount: Int?
}
