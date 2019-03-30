//
//  MapViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import GoogleMaps

class MapViewController: BaseViewController, GMSMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let spinner = Spinner()
    private let disposeBag = DisposeBag()
    private var mapView: GMSMapView?

    private let filter = PointFilter()

    private var allPoints: [PointItemShort] = []
    private var currentPoints: [PointItemShort] = []

    private var searchBar: UISearchBar!

    private var filterData = BehaviorRelay<PointFilter>(value: PointFilter())
    private var filterInit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
         locationManager.requestWhenInUseAuthorization()

        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 20))
        navigationItem.titleView = searchBar

        let filterImage = UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(onFilterButtonClicked))

        setupMap()
        
        initSpinner(spinner: spinner)
        spinner.start()

        MapViewModal.shared.getMapPointsByData()?
                .subscribe(onNext: { response in
                    if response.successful {
                        self.currentPoints = response.data ?? []
                        self.allPoints = response.data ?? []
                        self.showPointsOnMap(points: response.data ?? [])
                    } else {
                        // Вывести ошибку получения данных ?
                    }
                    self.spinner.end()
                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
                    self.spinner.end()
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)


        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        customView.backgroundColor = UIColor.white

        let closeButton = UIButton(frame: CGRect(x: 10, y: 0, width: view.frame.width / 2 - 10, height: 44))
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.contentHorizontalAlignment = .left
        closeButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        customView.addSubview(closeButton)

        let clearButton = UIButton(frame: CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2 - 10, height: 44))
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.contentHorizontalAlignment = .right
        clearButton.addTarget(self, action: #selector(clearSearchBar), for: .touchUpInside)
        customView.addSubview(clearButton)

        searchBar.inputAccessoryView = customView
        searchBar.delegate = self

        filterData.subscribe(onNext: { filter in
            if (!self.filterInit) {
                self.filterInit = true
            } else {
                self.setNewFilterData()
            }
        }).disposed(by: disposeBag)
    }

    private func setNewFilterData() {
        filter.categories = filterData.value.categories
        filter.districts = filterData.value.districts
        filterPointsByCategoriesOrDistricts()
        checkFilter()
    }

    private func filterPointsByCategoriesOrDistricts() {
        if (filter.categories.count > 0 || filter.districts.count > 0) {
            searchPoints()
        } else {
            self.showPointsOnMap(points: allPoints)
        }
    }

    @objc func onFilterButtonClicked(sender: UIBarButtonItem) {
        navigator?.openFilterViewController(filter: filterData)
    }

    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
        checkEmptySearchBar()
        checkFilter()
    }

    private func checkEmptySearchBar() {
        // Если в фильтре что то есть а серч баре пусто, делаем запрос на получение всех точек
        if ((searchBar.text == nil || searchBar.text!.count == 0) && filter.query != nil) {
            filter.query = nil
            filterPointsByCategoriesOrDistricts()
        }
    }

    @objc func clearSearchBar() {
        searchBar.text = nil
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let query = searchBar.text, query.count > 0 {
            filter.query = query
            searchPoints()
        } else {
            checkEmptySearchBar()
        }
        checkFilter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFilter()
    }

    private func checkFilter() {
        if (filter.active()) {
            navigationItem.rightBarButtonItem?.tintColor = .simpleBlue
        } else {
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }

    private func searchPoints() {
        self.spinner.start()
        MapViewModal.shared.getMapPointsByData(categories: filter.categories, districts: filter.districts, query: filter.query)?
                .subscribe(onNext: { response in
                    if response.successful {
                        self.currentPoints = response.data ?? []
                        self.showPointsOnMap(points: response.data ?? [])
                    } else {
                        // Вывести ошибку получения данных ?
                    }
                    self.spinner.end()
                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
                    self.spinner.end()
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)
    }

    private func showPointsOnMap(points: [PointItemShort]) {
        currentPoints = points
        mapView?.clear()

        points.forEach { point in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
            marker.title = point.desc?.name
            marker.map = mapView
            marker.userData = point.id

            if let icon = point.markerIcon {
                let markerImageView = UIImageView()

                markerImageView.kf.setImage(with: URL(string: icon)) { result in
                    switch result {
                    case .success(let value):
                        marker.icon = self.resizeImage(image: value.image, targetSize: CGSize(width: 40, height: 40))
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        if let id = marker.userData as? Int {
            showPointPreview(id: id)
        }
        return true
    }

    private func showPointPreview(id: Int) {
        if let pointIndex = currentPoints.firstIndex(where: { $0.id == id }) {
            let point = currentPoints[pointIndex]

            let width = view.frame.width - 40
            let count = Int((width / 16 * 9) / 20 + 1)
            var title = ""

            for _ in 0...count {
                title += "\n"
            }

            title += point.desc?.name ?? "" + "\n"
            let alert = UIAlertController(title: title, message: point.desc?.text, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Посмотреть", style: .default, handler: { alert in
                self.navigator?.openPointContentViewController(point)
            }))
            alert.addAction(UIAlertAction(title: "Открыть навигатор", style: .default, handler: { alert in
                self.openSelectMapApp(point: point)
            }))

            var coverView = UIImageView(frame: CGRect(x: 10, y: 10, width: view.frame.width - 40, height: 200))
            coverView.translatesAutoresizingMaskIntoConstraints = false
            coverView.contentMode = .scaleAspectFill
            coverView.clipsToBounds = true
            coverView.layer.cornerRadius = 5

            if let coverUrl = point.cover {
                coverView.kf.indicatorType = .activity
                coverView.kf.setImage(with: URL(string: coverUrl))
            }

            alert.view.addSubview(coverView)
            coverView.widthAnchor.constraint(equalToConstant: width).isActive = true
            coverView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
            alert.view.addConstraintsWithFormat(format: "V:|-10-[v0(\(width / 16 * 9))]", views: coverView)

            present(alert, animated: true)
        }
    }

    private func openSelectMapApp(point: PointItemShort?) {
        let alert = UIAlertController(title: "Веберите приложение", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Открыть Карты Apple", style: .default, handler: { alert in
            let url = "http://maps.apple.com/?q=\(point?.lat ?? 0),\(point?.lng ?? 0)&z=10&t=s"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }))
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            alert.addAction(UIAlertAction(title: "Открыть Карты Google", style: .default, handler: { alert in
                let url = "comgooglemaps://?q=\(point?.lat ?? 0),\(point?.lng ?? 0)&zoom=10"
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
        }
        if (UIApplication.shared.canOpenURL(URL(string:"mapsme://")!)) {
            alert.addAction(UIAlertAction(title: "Открыть Карты Maps.me", style: .default, handler: { alert in
                let url = "mapsme://search?query=\(point?.lat ?? 0),\(point?.lng ?? 0)"
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func setupMap() {
        view.subviews.forEach { view in
            view.removeFromSuperview()
        }

        let camera = GMSCameraPosition.camera(withLatitude: 7.982169, longitude: 98.344559, zoom: 10.5)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView!.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        mapView!.delegate = self
        mapView!.settings.scrollGestures = true
        mapView!.settings.zoomGestures = true
        mapView!.isMyLocationEnabled = true
        mapView!.settings.myLocationButton = true
        
        //Location Manager code to fetch current location
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        view.addSubview(mapView!)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10.5)
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }

    override func initBackButton() {
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
