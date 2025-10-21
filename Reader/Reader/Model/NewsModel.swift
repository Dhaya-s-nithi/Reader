//
//  NewsModel.swift
//  Reader
//
//  Created by Dhayanithi on 18/10/25.
//

import Foundation

struct NewsModel: Codable {
    let articles: [Article]
}
// MARK: - NewsProps
struct Article: Codable {
    let title: String?
    let description: String?
    let urlToImage: String?
   
}
