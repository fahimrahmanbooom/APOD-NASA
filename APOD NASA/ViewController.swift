//
//  ViewController.swift
//  APOD NASA
//
//  Created by Fahim Rahman on 16/12/19.
//  Copyright © 2019 Fahim Rahman. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class ViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewNasa: UIImageView!
    
    var nasaData = [Data]()
    
    // Find your's from https://api.nasa.gov/
    let ApiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromServer()
    }
    
    func getDataFromServer() {
        AF.request("https://api.nasa.gov/planetary/apod?api_key=\(ApiKey)").validate().responseJSON { response in
            
            guard let result = response.data else { return }
            do {
                self.nasaData = [try JSONDecoder().decode(Data.self, from: result)]
                
                for nasaData in self.nasaData {
                    
                    self.titleLabel.text = nasaData.title
                    self.dateLabel.text = nasaData.date
                    self.textView.text = nasaData.explanation
                    
                    let imageURL = nasaData.url
                    self.imageViewNasa.downloaded(from: imageURL ?? "")
                    self.imageViewNasa.contentMode = .scaleAspectFill
                }
            }
            catch {
                print(error)
            }
        }
    }
}
