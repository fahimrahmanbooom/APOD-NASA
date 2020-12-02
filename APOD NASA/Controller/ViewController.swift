//
//  ViewController.swift
//  APOD NASA
//
//  Created by Fahim Rahman on 16/12/19.
//  Copyright © 2019 Fahim Rahman. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


//-------------------------------------------------------------------------------------------------------------------------------------------------


// MARK: - Main View

class ViewController: UIViewController {
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewNasa: UIImageView!
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - Variables and Constants
    
    private var nasaData: NasaData?
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK: - API KEY
    
    // Find your key from https://api.nasa.gov/
    private let ApiKey = "W5gzE6yOfzawccdUM76kQ7SSsqQ596lLW5myxVSU"
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    // MARK:- APP Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDataFromServer()
    }
}



//-------------------------------------------------------------------------------------------------------------------------------------------------



// MARK: Get Data From NASA server

extension ViewController {
    
    func getDataFromServer() {
        
        AF.request("https://api.nasa.gov/planetary/apod?api_key=\(ApiKey)").validate().responseJSON { response in
            
            guard let result = response.data else { return }
            
            do {
                
                self.nasaData = try JSONDecoder().decode(NasaData.self, from: result)
                
                DispatchQueue.main.async {
                    
                    self.titleLabel.text = self.nasaData?.title
                    self.dateLabel.text = self.nasaData?.date
                    self.textView.text = self.nasaData?.explanation
                    
                    if let imageURL = self.nasaData?.url {
                        let url = URL(string: imageURL)
                        self.imageViewNasa.kf.setImage(with: url)
                        self.imageViewNasa.contentMode = .scaleAspectFill
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
