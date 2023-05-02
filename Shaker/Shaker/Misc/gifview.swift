//
//  gifview.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
//

import SwiftUI
import WebKit

struct gifview: UIViewRepresentable {
    private let name: String
    init(name:String) {
        self.name = name
    }
  
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = UIColor.clear
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        
        webView.load(data, mimeType:"image/gif", characterEncodingName: "Glass",
                     baseURL: url.deletingLastPathComponent() )
        webView.isUserInteractionEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
    
    typealias UIViewType = WKWebView
}

struct gifview_Previews: PreviewProvider{
    static var previews: some View {
        gifview(name: "Glass")
    }

}







