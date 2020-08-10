//
//  ViewController.swift
//  table
//
//  Created by Daria on 07.04.2020.
//  Copyright © 2020 Daria. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet private weak var myTableView: UITableView!
    
    private var infoInCell = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureURLRequest()
    }
    
    //MARK:- URLSession
    func configureURLRequest() {
        let session = URLSession(configuration: .default)
        let url =  URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=GIB6BDtU4H9UBHkAqnnDNysdpDALdnme")!
        let task = session.dataTask(with: url){ data, response, error in
        //let task = URLSession.shared.dataTask(with: url) { (data,response,error) in
            guard error == nil && data != nil  else {
            print("Client error!")
            return
                             }
            let json = try! JSON(data: data!)
 
            if let results = json ["results"].array
            {
                self.infoInCell.removeAll()
                for json in results
                {
                    if let section = json ["section"].string
                    {
                        self.infoInCell.append(section)
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                        print(section)
                    }
                }
                
            }
                        }
             task.resume()
            }}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoInCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Celldentifier", for: indexPath)
        cell.textLabel?.text = infoInCell[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(infoInCell[indexPath.row])
    }
}
