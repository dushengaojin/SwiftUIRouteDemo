//
//  ContentView.swift
//  SwiftUIRouteDemo
//
//  Created by Daolang Huang on 2022/7/30.
//

import SwiftUI
import SwiftUIRoute

enum MyRoute: String, Route {
    case pushOne
    case pushTwo
    case pushThree
    case uriPush = "domain/order/detail"
    case sheet
    case fullScreenCover
    
    var routeType: RouteType {
        switch self {
        case .sheet:
            return .sheet
        case .fullScreenCover:
            return .fullScreenCover
        default:
            return .push
        }
    }
    
    func start(context: Any?) -> some View {
        switch self {
        case .pushOne:
            return PushOne(context: context as? String).anyView
        case .pushTwo:
            return PushTwo().anyView
        case .pushThree, .uriPush:
            if let context = context as? [String: Any] {
                return PushThree(id: context["id"] as? String, type: context["type"] as? String).anyView
            }
            return PushThree(id: nil, type: nil).anyView
        case .sheet, .fullScreenCover:
            return PresentView().anyView
        }
    }
}

struct ContentView: View {
    init() {
        MyRoute.regist()
    }
    
    var body: some View {
        NavigationView {
            List {
                RouteView(uri: MyRoute.pushOne.rawValue, context: { "hello world" }) { _ in
                    Text("Text Push with context: hello world")
                }
                
                RouteView(uri: MyRoute.pushOne.rawValue) { isActive in
                    Button("Button push") {
                        isActive.wrappedValue.toggle()
                    }
                }
                
                RouteView(uri: MyRoute.sheet.rawValue) { isActive in
                    Button("Present sheet") {
                        isActive.wrappedValue.toggle()
                    }
                }
                
                RouteView(uri: MyRoute.fullScreenCover.rawValue) { isActive in
                    Button("Present fullScreenCover") {
                        isActive.wrappedValue.toggle()
                    }
                }
                
                RouteView(uri: "https://domain/order/detail?id=1&type=2") { _ in
                    Text("Push uri: https://domain/order/detail?id=1&type=2")
                }
            }
        }
    }
}

struct PushOne: View {
    let context: String?
    
    var body: some View {
        VStack {
            Text("context: \(context ?? "Empty")")
                .padding()
            RouteView(uri: MyRoute.pushTwo.rawValue) { _ in
                Text("Push To next page")
                    .padding()
            }
        }
    }
}

struct PushTwo: View {
    var body: some View {
        VStack {
            RouteView(uri: MyRoute.pushThree.rawValue) { _ in
                Text("Push To next page")
                    .padding()
            }
            
            Button("back to root") {
                MyRoute.backToRoot()
            }
            .padding()
        }
    }
}

struct PushThree: View {
    let id: String?
    let type: String?
    var body: some View {
        VStack {
            Text("id: \(id ?? ""), type: \(type ?? "")")
                .padding()
            Button("back to root") {
                MyRoute.backToRoot()
            }
            .padding()
            
            Button("back to page one") {
                MyRoute.backTo(path: MyRoute.pushTwo.rawValue)
            }
            .padding()
        }
    }
}

struct PresentView: View {
    var body: some View {
        NavigationView {
            RouteView(uri: MyRoute.pushOne.rawValue) { isActive in
                Button("Button push") {
                    isActive.wrappedValue.toggle()
                }
            }
        }
    }
}
