//
//  LoadingView.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 08/04/22.
//

import UIKit

private var loadingView: UIView?

extension UIViewController {

    func showLoading() {
        loadingView = UIView(frame: view.bounds)
        loadingView?.backgroundColor = .black.withAlphaComponent(0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemPink
        activityIndicator.center = loadingView!.center
        activityIndicator.startAnimating()
        loadingView?.addSubview(activityIndicator)
        self.view.addSubview(loadingView!)
    }

    func removeSpinner() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }

}
