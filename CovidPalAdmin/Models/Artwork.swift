//
//  Artwork.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import MapKit

class Artwork: NSObject, MKAnnotation {
    
    let state: String
    let uid: String
    let address: String
    let descriptionAddress: String
    let latitude: Double
    let longitude: Double
    let name: String
    let number: String
    let revNum: Int

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(
        state: String,
        uid: String,
        address: String,
        descriptionAddress: String,
        latitude: Double,
        longitude: Double,
        name: String,
        number: String,
        revNum: Int,
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D) {
        self.state = state
        self.uid = uid
        self.address = address
        self.descriptionAddress = descriptionAddress
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.number = number
        self.revNum = revNum
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }

}
