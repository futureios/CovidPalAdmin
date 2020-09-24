//
//  MapVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MapVC: UIViewController, MKMapViewDelegate {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    var ref: DatabaseReference!
    
    let nc = NotificationCenter.default
    
    var lastArtwork: Artwork?
    
    fileprivate let locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.requestWhenInUseAuthorization()
       return manager
    }()
    
    let mapView = MKMapView()
    
    let addLocationButton = UIButton()
    let sendLocationButton = UIButton()

    
    let detailView = UIView()
    
    let boxReviewsButton = UIButton()
    let boxEditButton = UIButton()
    let boxRemoveButton = UIButton()
    
    let imageColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    let textOneColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    let textTwoColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        nc.addObserver(self, selector: #selector(onAddLocation), name: Notification.Name("AddLocation"), object: nil)
                
        self.view.backgroundColor = UIColor.systemGray6

        mapViewInit()
        
        locationManagerInit()
        
        addLocationButtonInit()
        sendLocationButtonInit()
                
        getData()
    }
        
    func locationManagerInit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 11.0, *) {
           locationManager.showsBackgroundLocationIndicator = true
        }
        locationManager.startUpdatingLocation()
    }
    
    func mapViewInit() {
        mapView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height-(99+UIApplication.topSafeAreaHeight))
        mapView.delegate = self
        mapView.register(BaseArtworkView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(BaseArtworkView.self))
        mapView.register(ClusterArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        self.view.addSubview(mapView)
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        mapView.centerToLocation(initialLocation, latitudinal: mapView.latitudinalMeters(),longitudinal: mapView.longitudinalMeters())
        
    }
    
    func addLocationButtonInit() {
        addLocationButton.frame = CGRect(x: screenSize.width-60, y: screenSize.height-(220+UIApplication.topSafeAreaHeight), width: 45, height: 45)
        addLocationButton.layer.cornerRadius = 10
        addLocationButton.setImage(#imageLiteral(resourceName: "add-location").withRenderingMode(.alwaysTemplate), for: .normal)
        addLocationButton.tintColor = imageColor
        addLocationButton.contentVerticalAlignment = .fill
        addLocationButton.contentHorizontalAlignment = .fill
        addLocationButton.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        addLocationButton.addBlurEffect()
        addLocationButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(addLocationButton)
    }
    
    func sendLocationButtonInit() {
        sendLocationButton.frame = CGRect(x: screenSize.width-60, y: screenSize.height-(160+UIApplication.topSafeAreaHeight), width: 45, height: 45)
        sendLocationButton.layer.cornerRadius = 10
        sendLocationButton.setImage(#imageLiteral(resourceName: "send-cursor").withRenderingMode(.alwaysTemplate), for: .normal)
        sendLocationButton.tintColor = imageColor
        sendLocationButton.contentVerticalAlignment = .fill
        sendLocationButton.contentHorizontalAlignment = .fill
        sendLocationButton.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        sendLocationButton.addBlurEffect()
        sendLocationButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(sendLocationButton)
    }
    
    func detailViewInit(name: String, number: String, description: String, address: String, revNum: Int) {
        
        let detailWidth = screenSize.width-32
        
        let boxTitleLabel = UILabel()
        boxTitleLabel.frame = CGRect(x: 16, y: 10, width: detailWidth-32, height: 18)
        boxTitleLabel.text = name
        boxTitleLabel.textAlignment = .left
        boxTitleLabel.textColor = textOneColor
        boxTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        let boxPhoneLabel = UILabel()
        boxPhoneLabel.frame = CGRect(x: 18, y: 34, width: detailWidth-32, height: 8)
        boxPhoneLabel.text = number
        boxPhoneLabel.textAlignment = .left
        boxTitleLabel.textColor = textTwoColor
        boxPhoneLabel.font = UIFont.systemFont(ofSize: 10)
        let boxDetailLabel = UILabel()
        boxDetailLabel.frame = CGRect(x: 16, y: 50, width: detailWidth-32, height: 200)
        boxDetailLabel.text = description
        boxDetailLabel.textAlignment = .left
        boxDetailLabel.textColor = textOneColor
        boxDetailLabel.lineBreakMode = .byWordWrapping
        boxDetailLabel.numberOfLines = 0
        boxDetailLabel.font = UIFont.systemFont(ofSize: 11)
        boxDetailLabel.sizeToFit()
        let boxAddressTitleLabel = UILabel()
        boxAddressTitleLabel.frame = CGRect(x: 16, y: boxDetailLabel.bounds.height+58, width: detailWidth-32, height: 12)
        boxAddressTitleLabel.text = "Address:"
        boxAddressTitleLabel.textAlignment = .left
        boxAddressTitleLabel.textColor = textOneColor
        boxAddressTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        let boxAddressLabel = UILabel()
        boxAddressLabel.frame = CGRect(x: 80, y: boxDetailLabel.bounds.height+59, width: detailWidth-96, height: 12)
        boxAddressLabel.text = address
        boxAddressLabel.textAlignment = .left
        boxAddressLabel.textColor = textTwoColor
        boxAddressLabel.font = UIFont.systemFont(ofSize: 11)
        let boxNomberReviewsTitleLabel = UILabel()
        boxNomberReviewsTitleLabel.frame = CGRect(x: 16, y: boxDetailLabel.bounds.height+78, width: detailWidth-32, height: 12)
        boxNomberReviewsTitleLabel.text = "Number Of Reviews:"
        boxNomberReviewsTitleLabel.textAlignment = .left
        boxNomberReviewsTitleLabel.textColor = textOneColor
        boxNomberReviewsTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        let boxNomberReviewsLabel = UILabel()
        boxNomberReviewsLabel.frame = CGRect(x: 140, y: boxDetailLabel.bounds.height+79, width: detailWidth-156, height: 12)
        boxNomberReviewsLabel.text = String(revNum)
        boxNomberReviewsLabel.textAlignment = .left
        boxNomberReviewsLabel.textColor = textTwoColor
        boxNomberReviewsLabel.font = UIFont.systemFont(ofSize: 11)

        boxReviewsButton.frame = CGRect(x: detailWidth*0.04, y: boxDetailLabel.bounds.height+98, width: detailWidth*0.28, height: 30)
        boxReviewsButton.setTitle("Reviews", for: .normal)
        boxReviewsButton.setTitleColor(textOneColor, for: .normal)
        boxReviewsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        boxReviewsButton.layer.cornerRadius = 8
        boxReviewsButton.layer.borderWidth = 1
        boxReviewsButton.layer.borderColor = textTwoColor.cgColor
        boxReviewsButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        boxEditButton.frame = CGRect(x: (detailWidth*0.07)+(detailWidth*0.28), y: boxDetailLabel.bounds.height+98, width: detailWidth*0.28, height: 30)
        boxEditButton.setTitle("Edit", for: .normal)
        boxEditButton.setTitleColor(textOneColor, for: .normal)
        boxEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        boxEditButton.layer.cornerRadius = 8
        boxEditButton.layer.borderWidth = 1
        boxEditButton.layer.borderColor = textTwoColor.cgColor
        boxEditButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        
        boxRemoveButton.frame = CGRect(x: (detailWidth*0.1)+(detailWidth*0.56), y: boxDetailLabel.bounds.height+98, width: detailWidth*0.3, height: 30)
        boxRemoveButton.setTitle("Remove", for: .normal)
        boxRemoveButton.setTitleColor(#colorLiteral(red: 0.8242612481, green: 0.1633117199, blue: 0.07088655978, alpha: 0.7002622003), for: .normal)
        boxRemoveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        boxRemoveButton.layer.cornerRadius = 8
        boxRemoveButton.layer.borderWidth = 1
        boxRemoveButton.layer.borderColor = #colorLiteral(red: 0.8242612481, green: 0.1633117199, blue: 0.07088655978, alpha: 0.7002622003)
        boxRemoveButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)

        
        detailView.frame = CGRect(x: 16, y: statusBarHeight+12, width: screenSize.width-32, height: boxDetailLabel.bounds.height+138)
        detailView.layer.cornerRadius = 15
        detailView.addBlurEffectToView()

        
        self.view.addSubview(detailView)
        detailView.addSubview(boxTitleLabel)
        detailView.addSubview(boxPhoneLabel)
        detailView.addSubview(boxDetailLabel)
        detailView.addSubview(boxAddressTitleLabel)
        detailView.addSubview(boxAddressLabel)
        detailView.addSubview(boxNomberReviewsTitleLabel)
        detailView.addSubview(boxNomberReviewsLabel)
        detailView.addSubview(boxReviewsButton)
        detailView.addSubview(boxEditButton)
        detailView.addSubview(boxRemoveButton)
    }
    
//    func addRadiusCircle(radius: CLLocationDistance){
//        self.mapView.removeOverlays(mapView.overlays)
//        let location = mapView.annotations.filter { $0.isKind(of: BaseArtwork.self)}[0] as MKAnnotation
//        let circle = MKCircle(center: location.coordinate, radius: radius)
//        self.mapView.addOverlay(circle)
//    }
//
//    func addRadiusCircle(location: CLLocationCoordinate2D, radius: CLLocationDistance){
//        self.mapView.removeOverlays(mapView.overlays)
//        let circle = MKCircle(center: location, radius: radius)
//        self.mapView.addOverlay(circle)
//    }
    
    func addBaseArtwork(location: CLLocationCoordinate2D){
        mapView.removeAnnotations(mapView.annotations.filter { $0.isKind(of: BaseArtwork.self)})
        mapView.addAnnotation(BaseArtwork(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude:  location.latitude, longitude: location.longitude)))
    }
    
    func addAnnotation(state:String,uid:String,address:String,description:String,lat:Double,long:Double,name:String,number:String,revNum:Int) {
        let artwork = Artwork(state: state, uid: uid, address: address, descriptionAddress: description, latitude: lat, longitude: long, name: name, number: number, revNum: revNum, title: "", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
        mapView.addAnnotation(artwork)
    }
    
//    func addDistanceAnnotation(state:String,uid:String,address:String,description:String,lat:CGFloat,long:CGFloat,name:String,number:String) {
//        let artwork = Artwork(state: state, uid: uid, address: address, descriptionAddress: description, latitude: lat, longitude: long, name: name, number: number, title: "", subtitle: "", coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)))
//        mapView.addAnnotation(artwork)
//    }
    
//    func distanceFromLocation(userLocation: CLLocation, distance: Double) {
//        mapView.removeAnnotations(mapView.annotations.filter({ $0.isKind(of: Artwork.self)}))
//        for annotation in allAnnotation {
//            let annotationLocation = CLLocation(latitude: CLLocationDegrees(annotation.latitude), longitude: CLLocationDegrees(annotation.longitude))
//            let distanceFromLocation = userLocation.distance(from: annotationLocation)
//            if distanceFromLocation < distance {
//                addDistanceAnnotation(state: annotation.state, uid: annotation.uid, address: annotation.address, description: annotation.descriptionAddress, lat: annotation.latitude, long: annotation.longitude, name: annotation.name, number: annotation.number)
//            }
//        }
//    }
    
    func getData() {
        locationManager.startUpdatingLocation()
        mapView.removeAnnotations(mapView.annotations.filter({ $0.isKind(of: Artwork.self)}))
        ref.child("States").observeSingleEvent(of: .value, with: { snapshot in
            for childState in snapshot.children {
                let state_snap = childState as! DataSnapshot
                let state = state_snap.key
                for childUid in state_snap.children {
                    let uid_snap = childUid as! DataSnapshot
                    let uid = uid_snap.key
                    guard let dict_uid = uid_snap.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    let address = dict_uid["Address"] as? String
                    let description = dict_uid["Description"] as? String
                    let latitude = dict_uid["Latitude"] as? Double
                    let longitude = dict_uid["Longitude"] as? Double
                    let name = dict_uid["Name"] as? String
                    let number = dict_uid["Number"] as? String
                    if uid_snap.hasChild("Reviews") {
                        let reviews = (dict_uid["Reviews"] as? NSDictionary)?.allKeys.count
                        self.addAnnotation(state: state, uid: uid, address: address!, description: description!, lat: latitude!, long: longitude!, name: name!, number: number!, revNum: reviews!)
                    } else {
                        self.addAnnotation(state: state, uid: uid, address: address!, description: description!, lat: latitude!, long: longitude!, name: name!, number: number!, revNum: 0)
                    }
                }
            }
        })
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
      if sender === addLocationButton {
        
        let addLocatoinVC = storyBoard.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        addLocatoinVC.modalPresentationStyle = .formSheet
        addLocatoinVC.updateMode = false
        addLocatoinVC.artwork = nil
        self.present(addLocatoinVC, animated:true, completion:nil)
        
      } else if sender === sendLocationButton {
        locationManager.startUpdatingLocation()
      } else if sender === boxReviewsButton {
        reviewsButtonAlert()
      } else if sender === boxEditButton {
        
        let addLocatoinVC = storyBoard.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        addLocatoinVC.modalPresentationStyle = .formSheet
        addLocatoinVC.updateMode = true
        addLocatoinVC.artwork = lastArtwork
        self.present(addLocatoinVC, animated:true, completion:nil)
        
      } else if sender === boxRemoveButton {
        Database.database().reference().child("States").child(lastArtwork!.state).child(lastArtwork!.uid).removeValue { error, _ in
            if let er = error {
                print(er)
            }
            self.getData()
        }
      }
    
    }
    
    @objc func onAddLocation(notification: Notification) {
        getData()
    }
    
    
    func reviewsButtonAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "See the Reviews", style: .default, handler: { action in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let reviewsVC = storyBoard.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
            reviewsVC.modalPresentationStyle = .formSheet
            reviewsVC.state = self.lastArtwork?.state
            reviewsVC.uid = self.lastArtwork?.uid
            self.present(reviewsVC, animated:true, completion:nil)
        }))
        alert.addAction(UIAlertAction(title: "Post a Review", style: .default, handler: { action in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let postReviewsVC = storyBoard.instantiateViewController(withIdentifier: "PostReviewsVC") as! PostReviewsVC
            postReviewsVC.modalPresentationStyle = .formSheet
            postReviewsVC.state = self.lastArtwork?.state
            postReviewsVC.uid = self.lastArtwork?.uid
            postReviewsVC.reviewUID = ""
            postReviewsVC.updateMode = false
            postReviewsVC.reviewString = ""
            postReviewsVC.turnaroundString = ""
            self.present(postReviewsVC, animated:true, completion:nil)
        }))
        self.present(alert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
            case is Artwork:
              let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
              view.clusteringIdentifier = String(describing: ClusterArtworkView.self)
              return view
            case is BaseArtwork:
                return mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(BaseArtworkView.self), for: annotation)
            case is MKClusterAnnotation:
              return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
            default:
              return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is Artwork {
            mapView.centerToLocationBottom(CLLocation(latitude: view.annotation?.coordinate.latitude ?? 0, longitude: view.annotation?.coordinate.longitude ?? 0), latitudinal: mapView.latitudinalMeters(),longitudinal: mapView.longitudinalMeters())
            let data = view.annotation as! Artwork
            self.lastArtwork = data
            detailViewInit(name: data.name, number: data.number, description: data.descriptionAddress, address: data.address, revNum: data.revNum)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is Artwork {
            detailView.removeFromSuperview()
            detailView.subviews.forEach({ $0.removeFromSuperview() })
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKCircle :
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            circle.fillColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1).withAlphaComponent(0.4)
            circle.lineWidth = 1
            return circle
        default:
            return MKOverlayRenderer()
        }
    }
    
    
}


extension MapVC: CLLocationManagerDelegate {
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        addBaseArtwork(location: currentLocation)
        mapView.centerToLocation(location, latitudinal: 18000000, longitudinal: 18000000)
        locationManager.stopUpdatingLocation()
     }
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
     }
}




internal final class BaseArtworkView: MKMarkerAnnotationView {
    //  MARK: Properties
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
}
//  MARK: Configuration
private extension BaseArtworkView {
    func configure(with annotation: MKAnnotation) {
        guard annotation is BaseArtwork else { fatalError("Unexpected annotation type: \(annotation)") }
        markerTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    }
}



internal final class ClusterArtworkView: MKAnnotationView {
    //  MARK: Properties
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
    //  MARK: Initialization
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0.0, y: -10.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented.")
    }
}
//  MARK: Configuration
private extension ClusterArtworkView {
    func configure(with annotation: MKAnnotation) {
        guard let annotation = annotation as? MKClusterAnnotation else { return }
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40.0, height: 40.0))
        let count = annotation.memberAnnotations.count
        image = renderer.image { _ in
            #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).setFill()
            UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)).fill()
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}





private extension MKMapView {
    
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
    
    func centerToLocationBottom(
    _ location: CLLocation,
    latitudinal: CLLocationDistance,
    longitudinal: CLLocationDistance
    ) {
    let coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
      latitudinalMeters: latitudinal,
      longitudinalMeters: longitudinal)
    setRegion(coordinateRegion, animated: true)
    }
    
    func latitudinalMeters() -> CLLocationDistance {
        let span = self.region.span
        let center = self.region.center
        let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let metersInLatitude = loc1.distance(from: loc2)
        return metersInLatitude
    }

    func longitudinalMeters() -> CLLocationDistance {
        let span = self.region.span
        let center = self.region.center
        let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
        let metersInLongitude = loc3.distance(from: loc4)
        return metersInLongitude
    }
    
}

extension UIApplication {
    static var topSafeAreaHeight: CGFloat {
        var topSafeAreaHeight: CGFloat = 0
         if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = window.frame.maxY - safeFrame.maxY
             }
        return topSafeAreaHeight
    }
}
