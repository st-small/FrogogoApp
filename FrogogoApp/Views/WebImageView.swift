//
//  WebImageView.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    public func set(imageURL: String?) {
        
        currentUrlString = imageURL
        guard
            let imageURL = imageURL,
            let url = URL(string: imageURL) else {
                self.image = UIImage(named: "Avatar")
                return
        }
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentUrlString {
            image = UIImage(data: data)
        }
    }
}
