import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", model.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingMovie = results.first {
                print("Record already exists: \(existingMovie.original_title ?? "")")
                completion(.success(()))
                return
            }
            
            // Otherwise, create a new record and save it
            let item = MovieItem(context: context)
            
            item.original_title = model.original_title
            item.id = Int64(model.id)
            item.poster_path = model.poster_path
            item.vote_average = model.vote_average
            item.vote_count = Int64(model.vote_count)
            item.media_type = model.media_type
            item.overview = model.overview
            item.release_date = model.release_date
        
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingMoviesFromDataBase (completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            print(DataBaseError.failedToFetchData)
        }
    }
    
    func deleteMovieWith(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // ask database manager delete an object
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
        
    }
    
    func downloadTvWith(model: TV, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TvItem> = TvItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", model.id) // check if object with same id already exists
        
        do {
            let results = try context.fetch(request)
            if let existingTv = results.first { // if object found, don't save again
                print("Tv with id \(existingTv.id) already exists in Core Data.")
                completion(.success(()))
                return
            } else { // if object not found, create new TvItem object and save
                let item = TvItem(context: context)
                item.name = model.name
                item.id = Int64(model.id)
                item.poster_path = model.poster_path
                item.vote_average = model.vote_average
                item.vote_count = Int64(model.vote_count)
                item.media_type = model.media_type
                item.overview = model.overview
                item.release_date = model.release_date
                
                try context.save()
                completion(.success(()))
            }
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchingTvFromDataBase (completion: @escaping (Result<[TvItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TvItem>
        
        request = TvItem.fetchRequest()
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            print(DataBaseError.failedToFetchData)
        }
    }
    
    func deleteTvWith(model: TvItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
        
    }
}
