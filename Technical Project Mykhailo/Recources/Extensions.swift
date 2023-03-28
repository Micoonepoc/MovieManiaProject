import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        
        return self.prefix(1).capitalized + self.dropFirst().lowercased()
        
    }
}


