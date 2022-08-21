//
//  ApiClient.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation
import Alamofire

/*public protocol ApiClientProtocol {
    func getMoviesByCategory(sortBy: String, completion: @escaping(Result<DiscoverMoviesResponse, Error>) -> Void)
}*/

public struct DiscoverMoviesResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        //case page
        case results
    }
    
    //public let page: String
    public let results: [MovieDTOModel]
}

public class ApiClient {
    
    static let shared = ApiClient()
    
    public func getMoviesByCategory(sortBy: String = "popularity.desc", completion: @escaping (Result<DiscoverMoviesResponse, Error>) -> Void) {
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(Configuration.ApiKey)&sort_by=\(sortBy)"
        
        AF.request(url).response { response in
            switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                            return try ApiClient.decodeDate(decoder)
                        })
                        
                        let resp = try decoder.decode(DiscoverMoviesResponse.self, from: data!)
                        completion(.success(resp))
                    }
                    catch {
                        completion(.failure(.serializationError(internal: error)))
                        MessageBox.show(title: "Error", message: error.localizedDescription);
                    }
            case .failure(let error):
                completion(.failure(.networkError(internal: error)))
                MessageBox.show(title: "Error", message: error.localizedDescription);
            }
        }
    }
    
    
    public enum Error: Swift.Error {
        case serializationError(internal: Swift.Error)
        case networkError(internal: Swift.Error)
    }
    
    static func decodeDate(_ decoder : Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        
        var date = formatter.date(from: dateStr)
        if date == nil {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            date = formatter.date(from: dateStr)
        }
        if date == nil {
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSSSSS' 'Z"
            date = formatter.date(from: dateStr)
        }
        if date == nil {
            formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss' 'Z"
            date = formatter.date(from: dateStr)
        }
        if date == nil {
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: dateStr)
        }
        
        guard let _date = date else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        }
        
        return _date
    }
}
