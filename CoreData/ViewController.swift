//
//  ViewController.swift
//  CoreData
//
//  Created by Apple on 12/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    var result : [NSManagedObject] = []
    var myContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myContext = CoreDataManager.sharedInstance().getParentManagedContext()
        self.fetchData()
        self.getRecordAndSave()
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func getRecordAndSave(){
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "f292b4c2-15ac-c2d3-bf32-4f155034e355"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://app.brownstone.io/salesPerson/getLeadsBySalesPerson/60")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "")
            } else {
              //let httpResponse = response as? HTTPURLResponse
                if let record =  try? JSONDecoder().decode(ResponseGetLeads.self, from:data!){
                    self.saveDataAfterCallAsync(records: record, closure: {
                        self.fetchData()
                    })
                    
                } 
            }
        })
        
        dataTask.resume()
    }
    
    func fetchData(){
//
        CoreDataManager.sharedInstance().fetchAllRecordsForEntity(entityName: entityName.Lead.rawValue) { (ResultArray) in
            print(ResultArray.count)
            self.result = ResultArray
            self.myTableView.reloadData()
        }
//
//        CoreDataManager.sharedInstance().fetchSortedRecordsForEntity(entityName: entityName.Lead.rawValue, attribute: "name", isAscending: false) { (ResultArray) in
//            print(ResultArray.count)
//            self.result = ResultArray
//            self.myTableView.reloadData()
//        }
        
//        let name = "less info 4";
//        CoreDataManager.sharedInstance().fetchSortedRecordsForEntityPredicate(entityName: entityName.Lead.rawValue, predicate: NSPredicate(format: "name == %@", name), sortAttribute: "name", isAscending: true) { (ResultArray) in
//            print(ResultArray.count)
//            self.result = ResultArray
//            self.myTableView.reloadData()
//        }
//        CoreDataManager.sharedInstance().fetchAllRecordsForEntityPredicate(entityName: entityName.Lead.rawValue, predicate: NSPredicate(format: "name == %@", name)) { (ResultArray) in
//            print(ResultArray.count)
//            self.result = ResultArray
//            self.myTableView.reloadData()
//        }
        
        
//        CoreDataManager.sharedInstance().deleteRecordForEntity(entityName: entityName.Lead.rawValue) {
//            CoreDataManager.sharedInstance().fetchAllRecordsForEntity(entityName: entityName.Lead.rawValue) { (ResultArray) in
//                print(ResultArray.count)
//                self.result = ResultArray
//                self.myTableView.reloadData()
//            }
//        }
//
//        CoreDataManager.sharedInstance().deleteRecordPredicate(entityName: entityName.Lead.rawValue, predicate: NSPredicate(format: "name == %@", name)) {
//            CoreDataManager.sharedInstance().fetchAllRecordsForEntity(entityName: entityName.Lead.rawValue) { (ResultArray) in
//                                print(ResultArray.count)
//                                self.result = ResultArray
//                                self.myTableView.reloadData()
//                            }
//        }

    }
    
    func saveDataAfterCallAsync(records : ResponseGetLeads, closure: @escaping () -> Void){
        CoreDataManager.sharedInstance().deleteRecordForEntity(entityName: entityName.Lead.rawValue) {}
        CoreDataManager.sharedInstance().deleteRecordForEntity(entityName: entityName.Project.rawValue) {}
        
        let childContext = CoreDataManager.sharedInstance().getChildManagedContext()
        childContext.perform
          {
            for item in records.leads!{
                let leadObj = Lead(context: childContext)
                leadObj.leadid = String(item.id!)
                leadObj.name = item.name
                
                //for projects
                for projet in item.projects!{
                    let projObj = Project(context: childContext)
                    projObj.projectid = String(projet.id!)
                    projObj.name = projet.project_name ?? ""
                    projObj.lead = leadObj
                 }
              }
               CoreDataManager.sharedInstance().saveChildContext(childContext: childContext, parentContext: self.myContext)
               closure()
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? =
            myTableView?.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                                   reuseIdentifier: "Cell")
        }
    
        
        let objLead = result[indexPath.row] as! Lead
        var name : String = ""
        if let proj = objLead.project?.allObjects{
        
            if proj.count > 0{
                for item in proj{
                let project = item as! Project
                    name.append("\(project.name ?? ""),")
                }
                cell?.detailTextLabel?.text = name
            }
        }
        
        cell?.textLabel?.text = "\(objLead.name ?? "")"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 170
    }
    
}


