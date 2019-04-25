//
//  Incident.swift
//  playingWithJSONParsing
//
//  Created by Administrator on 1/16/19.
//  Copyright © 2019 Jason Kwak. All rights reserved.
//

import Foundation
public struct IncidentRootJSON: Decodable {
        let geoLocation: Geolocation?
        let locationDescription: String?
        let locationdesc: String?
        let roadway: String?
        let laneClosure: LaneClosure?
        let countyCode: Int?
    
    }

struct Geolocation: Decodable{
    var latitude:Double?
    var longitude: Double?
}

struct LaneClosure: Decodable{
    var laneThatAreBlocked:String?
    var incidentType: IncidentType?
}

struct IncidentType: Decodable{
    var name:String?
}
