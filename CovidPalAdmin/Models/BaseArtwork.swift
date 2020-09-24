//
//  BaseArtwork.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import MapKit

class BaseArtwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
