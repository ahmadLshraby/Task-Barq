//
//  VideosVC.swift
//  Task
//
//  Created by Ahmad Shraby on 5/1/20.
//  Copyright © 2020 sHiKoOo. All rights reserved.
//

import UIKit

class VideosVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Videos]()
    var search = UISearchController(searchResultsController: nil)           // Declare the searchController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search Video"
        search.searchBar.barTintColor = .white
        search.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        search.obscuresBackgroundDuringPresentation = true
        self.navigationItem.searchController = search
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.3437023163, green: 0.5453881621, blue: 0.2329338193, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        getVideos()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        self.navigationItem.searchController?.isActive = true
        self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        self.navigationItem.searchController?.searchBar.showsCancelButton = true
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        getVideos()
    }
    
    func getVideos() {
        shouldPresentLoadingView(true)
        VideosServices.instance.getVideos { (success) in
            if success == true {
                self.shouldPresentLoadingView(false)
                self.videos = VideosServices.instance.videosData
                self.animateTable()
            }else {
                self.shouldPresentLoadingView(false)
                let msg = VideosServices.instance.msg ?? ""
                self.shouldPresentAlertView(true, title: "", alertText: msg, actionTitle: "Ok", errorView: nil)
            }
        }
    }
    
    func animateTable() {
        tableView.reloadData()
        scrollToFirstRow()
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    
}


extension VideosVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCell {
            let video = videos[indexPath.row]
            
            cell.configureCell(video: video)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = videos[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "New_Controller") as? DetailedVC {
            vc.selectedImage = selectedVideo.thumb
            vc.selectedTitle = selectedVideo.title
            vc.selectedURL = selectedVideo.url
            vc.selectedDate = selectedVideo.created_at
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollToFirstRow() {
        if videos.count != 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    
    
}



extension VideosVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getVideos()
        }else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTxt = searchBar.text ?? ""
        videos = videos.filter{ ($0.title?.contains(searchTxt))! }
        tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
        self.navigationItem.searchController?.searchBar.showsCancelButton = false
        getVideos()
    }
    
    
}
