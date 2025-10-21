//
//  ViewController.swift
//  Reader
//
//  Created by Dhayanithi on 17/10/25.
//

import UIKit
import Kingfisher
import CoreData

class ViewController: UIViewController, NewsManagerDelegate {
    
    
    @IBOutlet weak var newsTable: UITableView!
    
    @IBOutlet weak var homeTabItem: UITabBarItem!
    
    var newsManager = NewsManager()
    
    var article = NewsModel(articles: [])
    
    var refreshControl = UIRefreshControl()
    
    var isFavorite : Bool = false
    var favoriteCount : Int = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsManager.managerDelegate = self
        newsManager.getNewsData()
        
        newsTable.delegate = self
        newsTable.dataSource = self
        newsTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsCardCell")
        
        refresh()
        
        
        print(KingfisherManager.shared)
        
    }
    
    func didUpdateNews(news : NewsModel){
        article = news
        DispatchQueue.main.async {
            self.newsTable.reloadData()
        }
        
    }
}
//MARK: TableView

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCardCell", for: indexPath) as! NewsTableViewCell
        
        cell.newsHeadingLavel.numberOfLines = 0
        cell.newsHeadingLavel.lineBreakMode = .byWordWrapping
        cell.newsHeadingLavel.text = article.articles[indexPath.row].title
        self.newsTable.rowHeight = 170
        
        cell.DescriptionText.numberOfLines = 0
        cell.DescriptionText.lineBreakMode = .byWordWrapping
        cell.DescriptionText.text = article.articles[indexPath.row].description
        
        cell.newsImage?.kf.indicatorType = .activity
        if(article.articles[indexPath.row].urlToImage != nil) {
            cell.newsImage?.kf.setImage(with: URL(string: article.articles[indexPath.row].urlToImage ?? "https://via.placeholder.com/150")!)
            cell.newsImage?.backgroundColor = .clear
            
        }
        return cell
    }
}

extension ViewController : UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completionHandler) in
        
            self.isFavorite = true
            self.favoriteCount += 1
            
            self.defaults.set(self.article.articles[indexPath.row].title, forKey: "title")
            self.defaults.set(self.article.articles[indexPath.row].description, forKey: "descriptionTitle")
            self.defaults.set(self.article.articles[indexPath.row].urlToImage, forKey: "imageURL")
            self.defaults.set(self.favoriteCount, forKey: "count")
            
            if let myString = self.defaults.string(forKey: "title") {
                print("String value: \(myString)")
            }
            
            self.homeTabItem.badgeValue = "\(self.favoriteCount)"
          

        }
        favoriteAction.backgroundColor = .green
        favoriteAction.image = UIImage(systemName: "bookmark.fill")
        return UISwipeActionsConfiguration(actions: [favoriteAction])
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { (action, view, completionHandler) in
            
            self.favoriteCount -= 1
            self.homeTabItem.badgeValue = "\(self.favoriteCount)"
            print(self.favoriteCount)
            
        }
        unfavoriteAction.backgroundColor = .red
        unfavoriteAction.image = UIImage(systemName: "bookmark.slash.fill")
        
        return UISwipeActionsConfiguration(actions: [unfavoriteAction])
    }
    
    
}


//MARK: Pull to Refresh

extension ViewController{
    
    func refresh(){
        newsTable.refreshControl = refreshControl
        newsTable.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    @objc func refreshData(){
        newsManager.getNewsData()
        self.newsTable.reloadData()
        if refreshControl.isRefreshing{
            self.refreshControl.endRefreshing()
        }
        
    }
    
}

