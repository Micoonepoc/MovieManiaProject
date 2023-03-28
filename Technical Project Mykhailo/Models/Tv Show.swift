import Foundation

struct TVs: Codable {
    
    let results: [TV]
}

// MARK: - Result
struct TV: Codable {
    
    
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
    
}
