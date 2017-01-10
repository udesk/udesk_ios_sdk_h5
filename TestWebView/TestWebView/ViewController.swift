//
//  ViewController.swift
//  TestWebView
//
//  Created by Mac开发机 on 2016/12/14.
//  Copyright © 2016年 American air. All rights reserved.
//

import UIKit
import WebKit

private let url = "http://udesksdk.udesk.cn/im_client/"

class ViewController: UIViewController {

    fileprivate lazy var testWK : WKWebView = { [weak self] in
        let testWK = WKWebView()
        testWK.uiDelegate = self
       // testWK.navigationDelegate = self
        testWK.frame = UIScreen.main.bounds
        let request = URLRequest(url: URL(string : url )!)
        testWK.load(request)
        return testWK
    }()


    fileprivate lazy var testWB : UIWebView = { [weak self] in
        let testWB = UIWebView()
        testWB.delegate = self
        testWB.frame = UIScreen.main.bounds
        let request = URLRequest(url: URL(string : url)!)
        testWB.loadRequest(request)
        return testWB
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

         setupBase()
    }

}

extension  ViewController {

    fileprivate func setupBase(){

//        let version = UIDevice.current.systemVersion
//        let floatVersion : Float? = Float(version)

//        if let ver = floatVersion {
//            if ver >= 8.0 {
//                view.addSubview(testWK)
//            }else{
//                view.addSubview(testWB)
//            }
//        }

         view.addSubview(testWB)
    }
}

extension ViewController : UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {

    }

    func webViewDidFinishLoad(_ webView: UIWebView) {

    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {

    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}


extension ViewController : WKUIDelegate, WKNavigationDelegate {

    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    // 内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    // 页面加载完成时调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }

    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }

    // 这个方法是服务器重定向时调用，即 接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

    }

    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {


    }

    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    }


}




