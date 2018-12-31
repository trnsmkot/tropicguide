//
//  WebViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController, UIWebViewDelegate {

    private var webView: UIWebView!

    private let spinner = Spinner()
    var tour: TourItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = tour?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        if let url = tour?.url, let tourUrl = URL(string: url) {
            webView.loadRequest(URLRequest(url: tourUrl))
        }

//        spinner.start()
    }

    @objc override func onBackButtonClicked(sender: UIBarButtonItem) {
        if let canGoBack = webView?.canGoBack, canGoBack {
            webView?.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
//        spinner.end()
    }

    private func setupViews() {
        view.backgroundColor = .white

        webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.delegate = self
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false

        view.addSubview(webView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
    }
}