//
//  Configuration.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 21.08.2022.
//

import Foundation
import UIKit

public final class Configuration {
    public static let ApiUrl: String = "https://api.themoviedb.org/3/discover/movie"
    public static let ImageUrl: String = "https://image.tmdb.org/t/p/original/"
    public static let ApiKey: String = "6a60b320af251a774b0fd81dc6f481e0"
    public static let MovieListPosterSize: CGSize = CGSize(width: 150, height: 250)
    public static let MovieListSectionHeight: Int = 300
}
