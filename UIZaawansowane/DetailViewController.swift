//
//  DetailViewController.swift
//  UIZaawansowane
//
//  Created by Michal on 11/4/17.
//  Copyright © 2017 Michal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var pasekDetail: UINavigationItem!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    
    @IBOutlet weak var tytulText: UITextField!
    @IBOutlet weak var wykonawcaText: UITextField!
    @IBOutlet weak var gatunekText: UITextField!
    @IBOutlet weak var rokText: UITextField!
    @IBOutlet weak var sciezkiText: UITextField!
    
    var schowek = AlbumSingleton.sharedInstance
    var rowIndex: Int = 0

    func configureView() {
        // Update the user interface for the detail item.
        pasekDetail.title = "Edycja rekordu " + String(rowIndex+1) + " z " + String(schowek.album.count)
            if let label1 = tytulText {
                label1.text = detailItem!["album"] as? String
            }
            if let label2 = wykonawcaText {
                label2.text = detailItem!["artist"] as? String
            }
            if let label3 = gatunekText {
                label3.text = detailItem!["genre"] as? String
            }
            if let label4 = rokText {
                label4.text = String(describing: detailItem!["year"]!)
            }
            if let label5 = sciezkiText {
                label5.text = String(describing: detailItem!["tracks"]!)
            }
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
  
    }
    
    @IBAction func editTytul(_ sender: Any) {
        AlbumSingleton.sharedInstance.album[rowIndex]["album"] = tytulText.text
    }
    @IBAction func editWykonawca(_ sender: Any) {
        AlbumSingleton.sharedInstance.album[rowIndex]["artist"] = wykonawcaText.text
    }
    @IBAction func editRok(_ sender: Any) {
        AlbumSingleton.sharedInstance.album[rowIndex]["year"] = rokText.text
    }
    @IBAction func editGatunek(_ sender: Any) {
        AlbumSingleton.sharedInstance.album[rowIndex]["genre"] = gatunekText.text
    }
    @IBAction func editSciezki(_ sender: Any) {
        AlbumSingleton.sharedInstance.album[rowIndex]["tracks"] = sciezkiText.text
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: [String: Any]? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

