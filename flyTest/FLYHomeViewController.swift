//
//  FLYHomeViewController.swift
//  flyTest
//
//  Created by vivek verma on 10/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import ObjectMapper

class FLYHomeViewController: UIViewController {

    private var tableView : UITableView?
    private var searchView : FLYSearchView?
    private var objectManager : FLYObjectManager?
    private var cities : [NSDictionary]?
    var agents : [Agent] = [Agent]()
    
    
    //MARK : - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.red
        objectManager = FLYObjectManager()
        self.p_initSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = CGRect(x: 0, y: 64, width: Globals.SCREEN_WIDTH, height: self.view.frame.height - 64)
        searchView?.frame = CGRect(x: 0, y: 64, width: Globals.SCREEN_WIDTH, height: self.view.frame.height - 64)
    }
    
    //MARK - private methods
    
    private func p_initSubViews() {
        self.setupNavigationBarProperties()
        self.p_setupTableView()
        self.p_setupSearchView()
    }
    
    private func setupNavigationBarProperties() {
        self.navigationItem.title = "Agents Search"
    }
    
    private func p_setupTableView() {
        tableView = UITableView()
        tableView?.backgroundColor = UIColor.white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FlyAgentTableViewCell.self, forCellReuseIdentifier:NSStringFromClass(FlyAgentTableViewCell.self))
        self.view.addSubview(tableView!)
    }
    
    private func p_setupSearchView() {
        searchView = FLYSearchView()
        searchView?.backgroundColor = Colors.WHITE_COLOR
        searchView?.delegate = self
        self.view.addSubview(searchView!)
    }
    
    func p_fetchData(lat : Double, long : Double) {
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
        if let value = response as AnyObject? {
            let businesses = value["businesses"] as? Array ?? []
            for business in businesses {
                let agent = Mapper<Agent>().map(JSONObject: business)
                agents.append(agent!)
            }
            tableView?.reloadData()
            searchView?.removeFromSuperview()
        }
    }
    
    private func p_handleFailure() {
        
    }
}

extension FLYHomeViewController : FLYSearchViewDelegate {
    func agentSearchedWithData(latitude: Double, longitude: Double) {
        self.p_fetchData(lat: latitude, long: longitude)
    }
}

extension FLYHomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FlyAgentTableViewCell.getHeightOfCell(agent: agents[indexPath.row])
    }
}

extension FLYHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.agents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FlyAgentTableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(FlyAgentTableViewCell.self), for: indexPath) as! FlyAgentTableViewCell
        cell.updateCellWithAgentModel(agent: agents[indexPath.row])
        return cell
    }
}
