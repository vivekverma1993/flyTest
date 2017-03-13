//
//  FLYSearchView.swift
//  flyTest
//
//  Created by vivek verma on 13/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit

protocol FLYSearchViewDelegate : class {
    func agentSearchedWithData(latitude : Double, longitude : Double)
}

class FLYSearchView: UIView {
    let searchBarHeight : CGFloat = 44.0
    
    weak var delegate : FLYSearchViewDelegate?
    private var searchBar : UISearchBar?
    private var tableView : UITableView?
    private var cities    : [NSDictionary]?
    var results           : [String] = [String]()
    var filteredCities    : [NSDictionary]?
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.p_getCityData()
        self.p_initSubviews()
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
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
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
        if (filteredCities?.count)! <= indexPath.row {
            return
        }
        
        let city : NSDictionary = filteredCities![indexPath.row]
        if (delegate != nil) {
            delegate?.agentSearchedWithData(latitude: city.object(forKey: "latitude") as! Double, longitude: city.object(forKey: "longitude") as! Double)
        }
    }
}

extension FLYSearchView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = self.results[indexPath.row]
        return cell
    }
}
