import Foundation

// MARK: - MoviePopular
struct Movies: Codable {
    
    let results: [Movie]
}

// MARK: - Result
struct Movie: Codable {
    
    
    let media_type: String?
    let id: Int
    let title: String?
    let poster_path: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    let original_title: String?
    let overview: String?
    
    
}
