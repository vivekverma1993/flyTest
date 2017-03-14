//
//  FLYHomeViewController.swift
//  flyTest
//
//  Created by vivek verma on 10/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import ObjectMapper
import PKHUD
import MapKit

class FLYHomeViewController: UIViewController {

    let topOffset : CGFloat = 64.0
    
    private var tableView : UITableView?
    var searchView : FLYSearchView?
    var mapView : FLYMapView?
    private var objectManager : FLYObjectManager?
    private var cities : [NSDictionary]?
    var noResult : Bool?
    var agents : [Agent] = [Agent]()
    var isFlipped : Bool?
    var currentLatitude : Double?
    var currentLongitude : Double?
    
    
    //MARK: - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.p_updateCurrentLocation(lat: 0.0000, long: 0.0000)
        self.noResult = true
        self.isFlipped = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.red
        objectManager = FLYObjectManager()
        self.p_registerNotifications()
        self.p_initSubViews()
    }
    
    private func p_registerNotifications() {
         NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [unowned self] notification in
            self.searchView?.checkLocation()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchView?.checkLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - action methods
    
    func p_searchClicked(sender : UIButton) {
        if (searchView?.isDescendant(of: self.view))! {
            searchView?.removeFromSuperview()
        } else {
            self.view.addSubview(searchView!)
        }
    }
    
    func p_viewToggleClicked(sender : UIButton) {
        if (searchView?.isDescendant(of: self.view))! {
            searchView?.removeFromSuperview()
        }
        
        if (self.isFlipped! == false)
        {
            UIView.transition(with: self.view, duration: 0.5, options:.transitionFlipFromRight, animations: { () -> Void in
                // self.aImageView!.image = UIImage(named: "2.jpg")
                //hear remove the imageview add new view, say flipped view
                self.tableView!.removeFromSuperview()
                self.view.addSubview(self.mapView!)
                self.mapView?.centerMapOnLocation(location: CLLocation.init(latitude: self.currentLatitude!, longitude: self.currentLongitude!))
            }, completion: { (Bool) -> Void in
                self.isFlipped! = true
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .done, target: self, action: #selector(FLYHomeViewController.p_viewToggleClicked(sender:)))
            })
        }
        else
        {
            UIView.transition(with: self.view, duration: 0.5, options:.transitionFlipFromLeft, animations: { () -> Void in
                //move back, remove flipped view and add the image view
                self.mapView!.removeFromSuperview()
                self.view.addSubview(self.tableView!)
            }, completion: { (Bool) -> Void in
                self.isFlipped! = false
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(FLYHomeViewController.p_viewToggleClicked(sender:)))
            })
        }
    }
    
    //MARK: - private methods
    
    private func p_initSubViews() {
        self.setupNavigationBarProperties()
        self.p_setupTableView()
        self.p_setupSearchView()
        self.p_setupMapView()
    }
    
    private func setupNavigationBarProperties() {
        self.navigationItem.title = "Agents Search"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(FLYHomeViewController.p_searchClicked(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(FLYHomeViewController.p_viewToggleClicked(sender:)))
    }
    
    private func p_setupTableView() {
        tableView = UITableView.init(frame: CGRect(x: 0, y: topOffset, width: Globals.SCREEN_WIDTH, height: self.view.frame.height - topOffset))
        tableView?.backgroundColor = UIColor.white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FlyAgentTableViewCell.self, forCellReuseIdentifier:NSStringFromClass(FlyAgentTableViewCell.self))
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier:NSStringFromClass(UITableViewCell.self))
        tableView?.tableFooterView = UIView.init(frame: .zero)
        self.view.addSubview(tableView!)
    }
    
    private func p_setupSearchView() {
        searchView = FLYSearchView.init(frame: CGRect(x: 0, y: topOffset, width: Globals.SCREEN_WIDTH, height: self.view.frame.height - topOffset))
        searchView?.backgroundColor = Colors.WHITE_COLOR
        searchView?.delegate = self
        self.view.addSubview(searchView!)
    }
    
    private func p_setupMapView() {
        mapView = FLYMapView.init(frame: CGRect(x: 0, y: topOffset, width: Globals.SCREEN_WIDTH, height: self.view.frame.height - topOffset))
    }
    
    func p_fetchData(lat : Double, long : Double) {
        HUD.show(.progress)
        agents.removeAll()
        mapView?.updateCurrentLocation(latitude: lat, longitude: long)
        self.p_updateCurrentLocation(lat: lat, long: long)
        let params : String = "Real Estate Agents&latitude=\(lat)&longitude=\(long)&radius=30000"
        let hostUrl : String = "https://api.yelp.com/v3/businesses/search?term="
        objectManager?.getObjectWithUrlPath(urlPath: hostUrl, params:params, success: { [weak self] response in
            self?.p_handleResponse(response: response!)
        }, failure: { [weak self] error in
            print("error")
            self?.p_handleFailure()
        });
    }
    
    private func p_handleResponse(response : AnyObject) {
        HUD.hide()
        if let value = response as AnyObject? {
            let businesses = value["businesses"] as? Array ?? []
            for business in businesses {
                let agent = Mapper<Agent>().map(JSONObject: business)
                agents.append(agent!)
            }
            if agents.count == 0 {
                noResult = true
            } else {
                noResult = false
            }
            mapView?.updateMapWithArtWorks(agents: agents)
            tableView?.reloadData()
            searchView?.removeFromSuperview()
        }
    }
    
    private func p_handleFailure() {
        HUD.hide()
        HUD.flash(.label("Unable to fetch results!"), onView: searchView!, delay: 2.0, completion: nil)
    }
    
    private func p_updateCurrentLocation(lat : Double, long : Double) {
        self.currentLatitude = lat
        self.currentLongitude = long
    }
}

extension FLYHomeViewController : FLYSearchViewDelegate {
    func agentSearchedWithData(latitude: Double, longitude: Double) {
        self.p_fetchData(lat: latitude, long: longitude)
    }
}

extension FLYHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.noResult!  {
            return 44.0
        }
        return FlyAgentTableViewCell.getHeightOfCell(agent: agents[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.noResult!  {
            self.view.addSubview(searchView!)
        }
    }
}

extension FLYHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noResult! ? 1 : self.agents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.noResult! {
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = "No Results for selected location\nSearch different location"
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            return cell
        } else {
            let cell : FlyAgentTableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(FlyAgentTableViewCell.self), for: indexPath) as! FlyAgentTableViewCell
            cell.updateCellWithAgentModel(agent: agents[indexPath.row])
            return cell
        }
        
    }
}
