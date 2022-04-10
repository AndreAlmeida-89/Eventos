//
//  MapViewController.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 08/04/22.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        title = "Mapa"
    }

    func setup(with event: Event) {
        let location = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let point = MKPointAnnotation(__coordinate: location, title: event.title, subtitle: nil)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(MKCoordinateRegion(center: location, span: span), animated: true)
        mapView.addAnnotation(point)
    }
}

extension MapViewController {
    private func layout() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
