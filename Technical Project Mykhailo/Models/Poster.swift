import Foundation


struct MyTestModel: Codable {
    let results: [TestModel]
}

struct TestModel: Codable {
    
    let media_type: String?
    let id: Int
    let title: String?
    let name: String?
    let original_name: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let original_title: String?
    let overview: String?
    
    let first_air_date: String?
    let backdrop_path: String?
    let original_language: String?
    
}

