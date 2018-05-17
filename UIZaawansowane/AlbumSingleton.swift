//
//  AlbumSingleton.swift
//  UIZaawansowane
//
//  Created by Michal on 11/4/17.
//  Copyright © 2017 Michal. All rights reserved.
//

import Foundation

class AlbumSingleton{
    static let sharedInstance = AlbumSingleton()
    private init() {}
    
    var album: [[String:Any]] = []
}
