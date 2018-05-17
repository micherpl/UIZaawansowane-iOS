//
//  MasterViewController.swift
//  UIZaawansowane
//
//  Created by Michal on 11/4/17.
//  Copyright © 2017 Michal. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var schowek = AlbumSingleton.sharedInstance
    var indexToDelete: Int = 0
    var czyNowyRekord: Bool = false
    var czyMogeKasowac: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let url = URL(string: "https://isebi.net/albums.php")
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let utwory = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                self.schowek.album = utwory
            } catch let error as NSError {
                print(error)
            }
        }).resume()
        while (schowek.album.count == 0){
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        var nowyRekord: [String:Any] = [:]
        nowyRekord["artist"] = " "
        nowyRekord["album"] = " "
        nowyRekord["genre"] = " "
        nowyRekord["year"] = " "
        nowyRekord["tracks"] = " "
        AlbumSingleton.sharedInstance.album.append(nowyRekord)
        czyNowyRekord = true
        indexToDelete = schowek.album.count-1
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    @objc
    func deleteObject(_ sender: Any?) {
        if(czyMogeKasowac==true && schowek.album.count != 0){
            schowek.album.remove(at: indexToDelete)
            let indexPath = IndexPath(row: indexToDelete, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        czyMogeKasowac = false
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            czyMogeKasowac = true
            if (czyNowyRekord == true) {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.rowIndex = indexToDelete
                czyNowyRekord = false
                let object = schowek.album[indexToDelete]
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteObject(_:)))
                controller.navigationItem.rightBarButtonItem = deleteButton
            } else {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.rowIndex = indexPath.row
                    indexToDelete = indexPath.row
                    let object = schowek.album[indexToDelete]
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteObject(_:)))
                    controller.navigationItem.rightBarButtonItem = deleteButton
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schowek.album.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = schowek.album[indexPath.row]
        cell.textLabel!.text = object["album"] as? String
        cell.detailTextLabel?.text = object["artist"] as! String + " " + String(describing: object["year"]!)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}

