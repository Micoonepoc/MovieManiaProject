import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: WatchLaterViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house.circle")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        vc3.tabBarItem.image = UIImage(systemName: "bookmark.circle")
        vc4.tabBarItem.image = UIImage(systemName: "person.circle")
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Watchlist"
        vc4.title = "Profile"
        
    
        vc1.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        vc3.tabBarItem.selectedImage = UIImage(systemName: "bookmark.circle.fill")
        vc4.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")

        
        
        tabBar.tintColor = .red
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
}
