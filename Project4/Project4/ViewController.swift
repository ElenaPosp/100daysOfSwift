//
//  ViewController.swift
//  Project4
//
//  Created by Елена Поспелова on 25/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    var progressView: UIProgressView!
    let webSites = ["apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupWebView()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        let url = URL(string: "https://" + webSites.first!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for webSite in webSites {
            ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    private func openPage(action: UIAlertAction) {
        guard let title = action.title else { return }
        guard let url = URL(string: "https://" + title) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return
        progressView.progress = Float(webView.estimatedProgress)
    }

    func webView(_ : WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        guard let host = url?.host else {
            decisionHandler(.cancel)
            return
        }

        for webSite in webSites {
            if host.contains(webSite) {
                decisionHandler(.allow)
                return
            }
        }
    }
}

