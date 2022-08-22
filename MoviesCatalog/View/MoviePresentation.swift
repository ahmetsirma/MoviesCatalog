//
//  MoviePresentation.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation


public class MoviePresentation: NSObject {
    public let title: String?
    public let overview: String?
    public let posterPath: String?
    public let releaseDate: Date?
    public let voteAverage: Double?
    public let voteCount: Int?
    
    init(title: String?, overview: String?, posterPath: String?, releaseDate: Date?, voteAverage: Double?, voteCount: Int?) {
            self.title = title
            self.overview = overview
            self.posterPath = posterPath
            self.releaseDate = releaseDate
            self.voteAverage = voteAverage
            self.voteCount = voteCount
            super.init()
        }
}
