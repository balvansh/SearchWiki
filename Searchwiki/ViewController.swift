//
//  ViewController.swift
//  Searchwiki
//
//  Created by Rajender Kumar on 24/04/17.
//  Copyright © 2017 Balvansh Heerekar. All rights reserved.
//

import UIKit
import Alamofire

struct wiki
{
    let mainImage: UIImage!
    let name: String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var wikis = [wiki]()
    
    @IBOutlet var searchBars: UISearchBar!

    var searchURL = String()
    
    typealias JSONStandard = [String: AnyObject]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        wikis.removeAll()
        
        let keywords = searchBars.text
        let findKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchURL = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=thumbnail&pithumbsize=50&pilimit=50&generator=prefixsearch&gpssearch=\(findKeywords!)"
    
        callAlamo(url: searchURL)
        searchBar.endEditing(true)
    }
    
    
    func callAlamo(url:String){
        
        Alamofire.request(url).response(completionHandler:{
            response in
            
            self.parseData(JSONData: response.data!)
            
            
        } )
        
    }
    func parseData(JSONData: Data)
    {
        do{
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.mutableContainers) as? JSONStandard
            print(readableJSON)
            if let query = readableJSON?["query"] as? JSONStandard{
                
                print(query," Here!! ")
                
                if let pages = query["pages"] as? JSONStandard {
                    print(pages," Check this! ")
                    for (_, page) in pages {
                        let id = page ["pageid"] as! Int
                        
                        print(id)
                        let index = page ["index"] as! Int
                        
                        let title = page ["title"] as! String
                        
                        if let thum = page ["thumbnail"] as? JSONStandard
                        {
                            let sourceur = thum["source"]
                            let mainImageURL = URL(string: thum["source"] as! String)
                            let mainImageData = NSData(contentsOf: mainImageURL!)
                            
                            let mainImage = UIImage(data: mainImageData as! Data)
                            print(sourceur)
                            
                            wikis.append(wiki.init(mainImage: mainImage, name: title))
                            self.tableView.reloadData()
                        }
                        
                        print(index)
                        
                    }
                    
                    
                }
            }
            
            
        }
        catch{
            
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wikis.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        
        mainImageView.image = wikis[indexPath.row].mainImage
        mainLabel.text = wikis[indexPath.row].name
        
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


