//
//  ViewController.swift
//  Alamofire5
//
//  Created by VISHAL on 23/05/20.
//  Copyright © 2020 VISHAL. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        getMethod()
        //        postMethod()
        //        downloadMethod()
        //        uploadMethod()
    }
    
    func getMethod(){
        AF.request("https://swapi.dev/api/films", method: .get, parameters: [:])
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    if let JSON = response.value as? [String: Any] {
                        print(JSON)
                    }
                case .failure(let error): break
                    // error handling
                }
        }
    }
    
    func postMethod(){
        let headers: HTTPHeaders = [
            .authorization(username: "test@email.com", password: "testpassword"),
            .accept("application/json")
        ]
        let parameters = ["category": "Movies", "genre": "Action"]
        
        AF.request("https://httpbin.org/headers", method: .get, parameters: parameters, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    if let JSON = response.value as? [String: Any] {
                        print(JSON)
                    }
                case .failure(let error): break
                    // error handling
                }
        }
    }
    
    func downloadMethod(){
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("image.png")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download("https://httpbin.org/image/png", to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
        }
        .response { response in
            debugPrint(response)
            if response.error == nil, let imagePath = response.fileURL?.path {
                let image = UIImage(contentsOfFile: imagePath)
            }
        }
    }
    
    func uploadMethod() {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(UIImage().pngData()!, withName: "file.png", fileName: "abc.png", mimeType: "image/jpeg")
        }, to: "https://httpbin.org/post", method: .get, headers: headers).uploadProgress { (progress) in
            print(progress.fractionCompleted)
        } .responseJSON { response in
            debugPrint(response.response)
        }
    }
    
}

