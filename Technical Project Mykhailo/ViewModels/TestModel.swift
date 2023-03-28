import UIKit

class MovieDetailViewModel {
    
    var movie: Movie?
    var trailerId: String?
    var movieFromRealm: MovieRealm?
    
    
    
    // MARK: - Public Methods
    
    func saveMovieToRealm(movie: Movie?) {
        guard let movie = movie else {
            return
        }
        MovieDataManager.shared.movieSave(movie: movie)
    }
    
    
    func deleteMovie(movie: Movie?) {
        guard let movie = movie else {
            return
        }
        let movieRealm = MovieDataManager.shared.getMovieToRealm(movie: movie)
        MovieDataManager.shared.deleteMovie(movie: movieRealm)
    }
    
}
