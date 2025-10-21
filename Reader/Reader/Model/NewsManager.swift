//
//  NewsManager.swift
//  Reader
//
//  Created by Dhayanithi on 20/10/25.
//

import Foundation
import Alamofire
import CoreData

protocol NewsManagerDelegate {
    func didUpdateNews(news: NewsModel)
}


struct NewsManager {
    //
    let newsURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8a3f24fc78de4ea9a62821a7dc6b6575"
    var managerDelegate : NewsManagerDelegate?
    
    func getNewsData(){
        
        
        if let url = URL(string: newsURL)  {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                if let safeData = data {
                    
                    if let news = self.jsondecoding(newsData: safeData){
        
                        managerDelegate?.didUpdateNews(news: news)
                        
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
    
    func jsondecoding(newsData : Data) -> NewsModel? {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsModel.self, from: newsData)
            print(decodedData.articles)
            return decodedData
        }
        catch{
            print(error)
            
        }
        return nil
    }
    
//    func saveToCoreData(model: NewsModel, context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "NewsEntity", in: context)!
//        let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
//
//        coreDataObject.setValue(model.articles[0].title, forKey: "title")
//        coreDataObject.setValue(model.articles[0].description, forKey: "descriptionTitle")
//        coreDataObject.setValue(model.articles[0].urlToImage, forKey: "imageURL")
//        
//        print(coreDataObject.value(forKey: "title"))
//        // Handle nested objects and relationships here if applicable
//        // For example, create a new DetailCoreDataEntity and set its relationship
//    }
//    
//    func saveContext(context: NSManagedObjectContext) {
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//

}


