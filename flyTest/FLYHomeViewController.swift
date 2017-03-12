//
//  FLYHomeViewController.swift
//  flyTest
//
//  Created by vivek verma on 10/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit

class FLYHomeViewController: UIViewController {
    private var tableView : UITableView?
    private var objectManager : FLYObjectManager?
    
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier:NSStringFromClass(UITableViewCell.self))
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
            print(value["businesses"] as? Array ?? [])
        }
    }
    
    private func p_handleFailure() {
        
    }
}

extension FLYHomeViewController : UITableViewDelegate {
    
}

extension FLYHomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(UITableViewCell.self), for: indexPath)
        return cell
    }
}
