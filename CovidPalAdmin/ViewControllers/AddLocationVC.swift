//
//  AddLocationVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var updateMode: Bool?
    var artwork: Artwork?
        
    fileprivate let locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.requestWhenInUseAuthorization()
       return manager
    }()
    
    let mapView = MKMapView()
    
    let cancelButton = UIButton()
    let doneButton = UIButton()
    
    let textOneColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewInit()
        
        locationManagerInit()
        
        topViewInit()
    }
    
    
    func locationManagerInit() {
        if updateMode! {
            mapView.addAnnotation(artwork!)
            mapView.centerToLocation(CLLocation(latitude: artwork!.latitude, longitude: artwork!.longitude), latitudinal: 18000000, longitudinal: 18000000)
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if #available(iOS 11.0, *) {
               locationManager.showsBackgroundLocationIndicator = true
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func mapViewInit() {
        mapView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        self.view.addSubview(mapView)
    }
    
    
    func topViewInit() {
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        topView.addBlurEffectToViewNo()
        
        cancelButton.frame = CGRect(x: 12, y: 0, width: 50, height: 50)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(textOneColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cancelButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let chooseLabel = UILabel()
        chooseLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        if updateMode! {
            chooseLabel.text = "Updating..."
        } else {
            chooseLabel.text = "Choose a Location"
        }
        chooseLabel.textAlignment = .center
        chooseLabel.textColor = textOneColor
        chooseLabel.font = UIFont.systemFont(ofSize: 15)
        
        doneButton.frame = CGRect(x: screenSize.width-60, y: 0, width: 50, height: 50)
        doneButton.setTitle("Next", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        
        self.view.addSubview(topView)
        topView.addSubview(chooseLabel)
        topView.addSubview(cancelButton)
        topView.addSubview(doneButton)
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        
        mapView.removeAnnotations(mapView.annotations)
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        
      if sender === cancelButton {
        dismiss(animated: true, completion: nil)
      } else if sender === doneButton {
        if mapView.annotations.count == 0 {
            Toast.show(message: "Choose a Location...", controller: self)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let addLocDataVC = storyBoard.instantiateViewController(withIdentifier: "AddLocDataVC") as! AddLocDataVC
            addLocDataVC.modalPresentationStyle = .formSheet
            addLocDataVC.lat = Double(mapView.annotations[0].coordinate.latitude)
            addLocDataVC.long = Double(mapView.annotations[0].coordinate.longitude)
            addLocDataVC.updateMode = updateMode
            addLocDataVC.artwork = artwork
            weak var pvc = self.presentingViewController
            self.dismiss(animated: true, completion: {
                pvc?.present(addLocDataVC, animated: true, completion: nil)
            })

        }
      }
        
    }
    
    
    
}



extension AddLocationVC: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        mapView.centerToLocation(location, latitudinal: 18000000, longitudinal: 18000000)
        locationManager.stopUpdatingLocation()
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
     }
}




private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
    func centerToLocation(
    _ location: CLLocation,
    latitudinal: CLLocationDistance,
    longitudinal: CLLocationDistance
    ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: latitudinal,
      longitudinalMeters: longitudinal)
    setRegion(coordinateRegion, animated: true)
    }
    
}
