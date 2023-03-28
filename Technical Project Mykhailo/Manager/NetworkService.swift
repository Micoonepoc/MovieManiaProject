import Foundation
import Alamofire

struct Constants {
    static let API_Key = "94d08166b5815e494780bb20b721925a"
    static let baseURL = "https://api.themoviedb.org/"
    static let YouTubeAPI_Key = "AIzaSyDKGfEUX4WquXhoNh-rk6T4rqoq9zXgftw"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum NetrworkError: Error {
    case failedData
}


class NetworkService {
    static let shared = NetworkService()
 
    
    // MARK: - With Alamofire
    
    func fetchPopularMoviesAF(completion: @escaping ([Movie]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: Movies.self) { (response) in
                //                guard let movies = response.result else { return }
                //                completion(movies)
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
    
    func fetchUpcomingMoviesAF(completion: @escaping ([Movie]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: Movies.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    
    func fetchTopRatedMoviesAF (completion: @escaping ([Movie]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: Movies.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
    
    func searchTestAF (with query: String, completion: @escaping ([TestModel]) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        AF.request("\(Constants.baseURL)/3/search/multi?api_key=\(Constants.API_Key)&query=\(query)")
            .validate()
            .responseDecodable (of: MyTestModel.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
        
    func getYouTubeResponse(with query: String, completion: @escaping (VideoElement) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        AF.request("\(Constants.YouTubeBaseURL)q=\(query)&key=\(Constants.YouTubeAPI_Key)")
            .validate()
            .responseDecodable (of: YouTubeSearchResponse.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.items[0])
                case let .failure(error):
                    print(error)
                }
                
            }
        
    }
    
    func fetchPopularTvAF(completion: @escaping ([TV]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/tv/popular?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: TVs.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
    
    func fetchUpcomingTvAF(completion: @escaping ([TV]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/tv/top_rated?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: TVs.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case .failure(let error):
                    print(error)
                }
                
            }
    }
    
    
    func fetchTopRatedTvAF (completion: @escaping ([TV]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/tv/top_rated?api_key=\(Constants.API_Key)")
            .validate()
            .responseDecodable (of: TVs.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
    
    func discoverMovie (completion: @escaping ([Movie]) -> Void) {
        
        AF.request("\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_Key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate")
            .validate()
            .responseDecodable (of: Movies.self) { (response) in
                switch response.result {
                case .success(let result):
                    completion(result.results)
                case let .failure(error):
                    print(error)
                }
                
            }
    }
    
    
}
        
    

