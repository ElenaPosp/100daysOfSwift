//
//  DetailViewController.swift
//  Project7
//
//  Created by Елена Поспелова on 03/06/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView = WKWebView()
    var detailItem: Petition?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
        
        loadHTML()
    }

    func loadHTML() {
        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        
    }
}
