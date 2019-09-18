//
//  AnalogsCollectionView.swift
//  ankportal
//
//  Created by Олег Рачков on 11/04/2019.
//  Copyright © 2019 Academy of Scientific Beuty. All rights reserved.
//


import Foundation
import  UIKit
var productNamesByImageUrl: [String: String] = [:]

class AnalogsCollectionView: UICollectionViewInTableViewCell {
    var mainPageController: AnalogsCollectionViewInTableViewCell?
    
    private let cellId = "newProductInfoCell"
    var countOfPhotos: Int = 0
    var imageURL: String?
    let layout = UICollectionViewFlowLayout()
    var analogs: [String] = []
    
    var images: [UIImage] = []
    var imagesUrl: [String] = []
    var ids: [String] = []
    
    var firstRetrieveKey: Bool = true
    var endOfRetrieveKey: Bool = false
    lazy var restQueue: RESTRequestsQueue = RESTRequestsQueue()
    
    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.layout.scrollDirection = .horizontal
        
        self.layout.minimumLineSpacing = frame.height*0.2
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.contentInset.left = 10
        self.contentInset.right = 10
        self.register(NewProductInfoCell.self, forCellWithReuseIdentifier: self.cellId)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func retrieveImages() {
        
        let analogsArray = mainPageController!.analogs
        
        for i in 0...analogsArray.count-1 {
            let request = ANKRESTService(type: .productDetail)
            request.add(parameters: [
                RESTParameter(filter: .id, value: analogsArray[i]),
                RESTParameter(filter: .isTest, value: "Y")
                ])
            restQueue.add(request: request, completion: { [weak self] (data, respone, error) in
                if ( error != nil ) {
                    print(error!)
                    return
                }
                
                do {
                    if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        let productsInfo = ProductInfo(json: jsonObj)
                        
                        productNamesByImageUrl.updateValue(productsInfo.name, forKey: productsInfo.detailedPictureUrl)
                        
                        if productsInfo.detailedPictureUrl != "" {
                            
                            let imageUrl = productsInfo.detailedPictureUrl
                            
                            if let image = imageCache.object(forKey: imageUrl as AnyObject) as! UIImage? {
                                self!.imagesUrl.append(imageUrl)
                                self!.images.append(image)
                                self!.ids.append(analogsArray[i])
                                DispatchQueue.main.async {
                                    self!.reloadData()
                                }
                            } else {
                                let url = URL(string: imageUrl)
                                URLSession.shared.dataTask(with: url!,completionHandler: {(data, result, error) in
                                    if data != nil {
                                        if self != nil {
                                            let image = UIImage(data: data!)
                                            
                                            self!.imagesUrl.append(imageUrl)
                                            self!.images.append(image!)
                                            self!.ids.append(analogsArray[i])
                                            
                                            imageCache.setObject(image!, forKey: imageUrl as AnyObject)
                                            DispatchQueue.main.async {
                                                self!.reloadData()
                                            }
                                        }
                                    }
                                }
                                    ).resume()
                            }
                            
                            
                        }
                        
                    }
                } catch let jsonErr {
                    print (jsonErr)
                }
                
                }
            )
            
        }
        
        endOfRetrieveKey = true
        
    }
    
}


extension AnalogsCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height*0.9, height: collectionView.frame.height*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ids.count > 0 && endOfRetrieveKey {
            return ids.count
        } else {
            return (mainPageController?.analogs.count)!
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoViewController = ProductInfoTableViewController()
        
        let cell = collectionView.cellForItem(at: indexPath) as! NewProductInfoCell
        let image = cell.photoImageView.image
        if image != nil {
            productInfoViewController.productId = ids[indexPath.row]
            firstPageController?.navigationController?.pushViewController(productInfoViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (mainPageController?.analogs.count)! > 0 && firstRetrieveKey {
            firstRetrieveKey = false
            retrieveImages()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! NewProductInfoCell
        cell.photoImageView.image = nil
        cell.productNameLabel.text = ""

        if images.count > 0 {
                    if indexPath.row < self.images.count && indexPath.row < self.imagesUrl.count  {
                        cell.photoImageView.image = self.images[indexPath.row]
                        let sss = productNamesByImageUrl[self.imagesUrl[indexPath.row]]
                        cell.productNameLabel.text = sss
                        cell.activityIndicator.stopAnimating()
                    }
        }
        
        return cell
    }
    
}
