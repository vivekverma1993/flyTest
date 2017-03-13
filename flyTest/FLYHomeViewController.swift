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
    private var objectManager : FLYObjectManager?
    var agents : [Agent] = [Agent]()
    //MARK : - life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        objectManager = FLYObjectManager()
        self.p_initSubViews()
        self.p_fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = CGRect(x: 0, y: 0, width: Globals.SCREEN_WIDTH, height: Globals.SCREEN_HEIGHT)
    }
    
    //MARK - private methods
    
    private func p_initSubViews() {
        self.p_setupTableView()
    }
    
    private func p_setupTableView() {
        tableView = UITableView()
        tableView?.backgroundColor = UIColor.white
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(FlyAgentTableViewCell.self, forCellReuseIdentifier:NSStringFromClass(FlyAgentTableViewCell.self))
        self.view.addSubview(tableView!)
    }
    
    private func p_fetchData() {
        let params : String = "Real Estate Agents&latitude=37.786882&longitude=-122.399972&radius=30000"
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
        }
    }
    
    private func p_handleFailure() {
        
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
