//
//  FLYSearchView.swift
//  flyTest
//
//  Created by vivek verma on 13/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD

protocol FLYSearchViewDelegate : class {
    func agentSearchedWithData(latitude : Double, longitude : Double)
}

class FLYSearchView: UIView {
    let searchBarHeight : CGFloat = 44.0
    
    weak var delegate     : FLYSearchViewDelegate?
    var searchBar : UISearchBar?
    var tableView : UITableView?
    private var cities    : [NSDictionary]?
    var results           : [String] = [String]()
    var filteredCities    : [NSDictionary]?
    var locationManager = CLLocationManager()
    var userLocation      : CLLocation?
    var locationEnabled   : Bool?
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.p_getCityData()
        self.p_initSubviews()
        self.p_fetchLocation()
    }
    
    func checkLocation() {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .notDetermined) {
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
                {
                    locationManager.requestWhenInUseAuthorization()
                }
                locationManager.startUpdatingLocation()
                (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? (locationEnabled = true) : (locationEnabled = false)
                self.tableView?.reloadData()
            }
            else
            {
                locationEnabled = false
                HUD.flash(.label("Location service disabled"), onView: self, delay: 1.0, completion: nil)
            }
        }
    }
    
    private func p_fetchLocation() {
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .notDetermined) {
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                if ((UIDevice.current.systemVersion as NSString).floatValue >= 8)
                {
                    locationManager.requestWhenInUseAuthorization()
                }
                locationManager.startUpdatingLocation()
                (CLLocationManager.authorizationStatus() == .authorizedWhenInUse) ? (locationEnabled = true) : (locationEnabled = false)
            }
            else
            {
                locationEnabled = false
                HUD.flash(.label("Location service disabled"), onView: self, delay: 1.0, completion: nil)
            }
        } else {
            showAlertForLocation()
        }
    }
    
    func showAlertForLocation() {
        let alert : UIAlertController = UIAlertController(title: "Location denied", message: "Please provide access to your location", preferredStyle: .alert)
        
        let settingsAction : UIAlertAction = UIAlertAction(title: "Settings", style:.cancel , handler: { (alertAction) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString) as! URL, options:[:], completionHandler: nil)
        })
        
        alert.addAction(settingsAction)
        
        let cancelAction : UIAlertAction  = UIAlertAction(title: "cancel", style:.default , handler:nil)
        alert.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.frame = CGRect(x: 0, y: searchBarHeight, width: self.frame.width, height: self.frame.height - searchBarHeight)
        searchBar?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: searchBarHeight)
    }
    
    //MARK: - public methods
    
    func updateViewWithCityData(array : [NSDictionary]) {
        cities = array
    }
    
    //MARK: - private methods
    
    private func p_initSubviews() {
        results = [String]()
        filteredCities = [NSDictionary]()
        tableView = UITableView()
        tableView?.backgroundColor = UIColor.white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier:NSStringFromClass(UITableViewCell.self))
        self.addSubview(tableView!)
        
        searchBar = UISearchBar()
        searchBar?.placeholder =  "Search US cities for Agents"
        searchBar?.delegate = self
        self.addSubview(searchBar!)
    }
    
    private func p_getCityData() {
        cities = CitiesData.sharedInstance.cityDataArray
    }
    
    func p_searchForCity(str : String) {
        results.removeAll()
        filteredCities?.removeAll()
        
        let namePredicate = NSPredicate(format: "city CONTAINS[cd] %@",  String(str));
        let filteredArray = cities?.filter { namePredicate.evaluate(with: $0) };
        filteredCities = filteredArray
        for result in filteredArray! {
            let value = result as NSDictionary
            let city = value.object(forKey: "city") as! String
            let state = value.object(forKey: "state") as! String
            results.append("\(city), \(state)")
        }
        tableView?.reloadData()
    }
}

extension FLYSearchView : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.p_searchForCity(str: searchText)
    }
}

extension FLYSearchView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if (CLLocationManager.authorizationStatus() == .denied) {
                self.showAlertForLocation()
                return
            }
            
            if (self.delegate != nil) {
                self.delegate?.agentSearchedWithData(latitude: (self.userLocation?.coordinate.latitude)!, longitude: (self.userLocation?.coordinate.longitude)!)
            }
            break
        case 1:
            if (self.filteredCities?.count)! <= indexPath.row {
                return
            }
            
            let city : NSDictionary = self.filteredCities![indexPath.row]
            if (self.delegate != nil) {
                self.delegate?.agentSearchedWithData(latitude: city.object(forKey: "latitude") as! Double, longitude: city.object(forKey: "longitude") as! Double)
            }
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchBar?.setShowsCancelButton(false, animated: true)
    }
}

extension FLYSearchView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.results.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(UITableViewCell.self), for: indexPath)
        switch indexPath.section {
        case 0:
            var textColor : UIColor = Colors.GRAY_COLOR
            if self.locationEnabled == true {
                textColor = Colors.BLUE_COLOR
            }
            let attributedString : NSMutableAttributedString = NSMutableAttributedString.init()
            let iconText : NSAttributedString = NSAttributedString.init(string: Icons.LOCATION_ICON, attributes: [NSForegroundColorAttributeName: textColor , NSFontAttributeName: UIFont.init(name: Globals.ICON_FONT, size: 15) ?? UIFont.systemFont(ofSize: 15)])
            attributedString.append(iconText)
            attributedString.append(NSAttributedString.init(string: "  "))
            let attributedText : NSAttributedString = NSAttributedString(string: "Current Location", attributes: [NSForegroundColorAttributeName: textColor, NSFontAttributeName: UIFont.systemFont(ofSize: 15)])
            attributedString.append(attributedText)
            cell.textLabel?.attributedText = attributedString.copy() as? NSAttributedString
            break
        case 1:
            cell.textLabel?.text = self.results[indexPath.row]
            break
        default: break
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.results.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Nearby"
        case 1:
            return "Search Results"
        default:
            return ""
        }
    }
}

extension FLYSearchView : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationEnabled = true
            self.tableView?.reloadData()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        HUD.flash(.label("Unable to fetch location"), onView: self, delay: 1.0, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        self.userLocation = locationObj
    }
}
