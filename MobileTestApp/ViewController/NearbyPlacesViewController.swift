//
//  NearbyPlacesViewController.swift
//  MobileTestApp
//
//  Created by Sabika Batool on 9/5/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

class NearbyPlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nearbyPlacesArr = [[String:Any]]()
    var latitude = Double()
    var longitude = Double()
    var radius = Int()
    var type = String()
    var keyword = String()

    @IBOutlet weak var restaurantTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Nearby Restaurants"
        restaurantTableView.register(UINib(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        initializer()
        getPlacesList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializer() {
        radius = 500
        type = "restaurant"
        keyword = "food"
    }

    // MARK: - UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    // MARK: - UITableViewDataSource Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyPlacesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlacesTableViewCell
        cell.placeNameLbl.text = nearbyPlacesArr[indexPath.row]["name"] as? String
        cell.placeRatingLbl.text = String(describing: nearbyPlacesArr[indexPath.row]["rating"] as! NSNumber)
        cell.placeImageView.sd_setImage(with: URL(string: (nearbyPlacesArr[indexPath.row]["icon"] as? String)!), placeholderImage: UIImage(named: ""))
        return cell
    }
    
    // MARK - Service Call
    
    func getPlacesList(){
        let urlStr = KWEB_GET_MAP_LOCATION + "location=" + "\(latitude)" + "," + "\(longitude)" + "&radius=" + "\(radius)" + "&type=" + "\(type)" + "&keyword=" + "\(keyword)" + "&key=" + GoogleMapKey
        
        ServiceModel.sharedModel.getData(urlString: urlStr, loaderTxt: "Loading..", parameters: nil as Dictionary<String, AnyObject>?, success: {(AnyObject) -> Void in
            
            if AnyObject.object(forKey: "status") as? String == "OK"{
                if let dict = AnyObject as? [String: AnyObject] {
                    self.nearbyPlacesArr = dict["results"] as! [[String : AnyObject]]
                    if self.nearbyPlacesArr.count>0{
                        //self.showPlacesAnnotation()
                        self.restaurantTableView.reloadData()
                    }
                }
            }else{
                self.popupAlert(title: "Information", message: "You have exceeded your 1 request per day quota for this API. Please try a new API ", actionTitles: ["OK"], actions:[{action1 in
                    }, nil])
            }
        }, failure: {(NSError) -> Void in
        })
    }
}

//Popup Alert

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
