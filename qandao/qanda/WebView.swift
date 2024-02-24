//
//  WebView.swift
//  qanda
//
//  Created by bill donner on 7/6/23.
//

import SwiftUI
 import WebKit

struct WebView: View {
  let url:URL
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    ZStack {
      WebViewx(url:url)
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        VStack {
          HStack{ Spacer() ;  Image(systemName: "xmark.circle").padding()}
          Spacer()
        }
      }
    }
  }
}

struct WebViewx: UIViewRepresentable {
  let url:URL 
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.load(URLRequest(url: url))
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.load(URLRequest(url: url))
  }
}
struct WebView_Previews: PreviewProvider {
  static var previews: some View {
    WebView(url: URL(string:"https://www.apple.com")!)
      .edgesIgnoringSafeArea(.all)
  }
}
