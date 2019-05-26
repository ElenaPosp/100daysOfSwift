//
//  ViewController.swift
//  Project4
//
//  Created by Елена Поспелова on 25/05/2019.
//  Copyright © 2019 Елена Поспелова. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController {

    private var webView: WKWebView!
    var progressView: UIProgressView!
    var tableView: UITableView!
    let webSites = ["apple.com", "hackingwithswift.com", "translate.google.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupWebView()
        setupTableView()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    private func setupWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
    }

    private func setupNavBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let back = UIBarButtonItem(barButtonSystemItem: .undo, target: webView, action: #selector(webView.goForward))
        let next = UIBarButtonItem(barButtonSystemItem: .redo, target: webView, action: #selector(webView.goBack))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissWebView))
        toolbarItems = [cancel,progressButton, spacer, back, next, refresh]
        navigationController?.isToolbarHidden = false
    }

//    @objc func openTapped() {
//        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "vk.com", style: .default, handler: openPage))
//        for webSite in webSites {
//            ac.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
//        }
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        present(ac, animated: true)
//    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        progressView.progress = Float(webView.estimatedProgress)
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        view.addSubview(tableView)
    }
    
    @objc func dismissWebView() {
        view = tableView
        title = ""
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ : WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
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

        let ac = UIAlertController(title: "This site dont allowed", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = webSites[indexPath.row]
        guard let url = URL(string: "https://" + title) else { return }
        webView.load(URLRequest(url: url))
        view = webView
    }
}
