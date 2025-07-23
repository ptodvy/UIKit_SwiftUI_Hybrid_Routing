//
//  NavigationRouter.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import Combine
import UIKit
import SwiftUI

@MainActor
class NavigationRouter: ObservableObject {
    weak var navigationController: UINavigationController?
    @Published var subPath: SubPath = .init() {
        willSet {
            syncPathStack(newValue)
            print("subPath: \(newValue)")
        }
    }
    private var path: [Screen] = [] {
        didSet {
            print("path: \(path)")
        }
    }
    
    var isEmptySubPath: Bool {
        return subPath.isEmpty
    }
    
    func push(_ screen: SubScreen) {
        subPath.append(screen)
    }
    
    func pop() {
        guard !subPath.isEmpty else { return }
        subPath.removeLast()
    }
    
    func popToSubRoot() {
        guard !subPath.isEmpty else { return }
        subPath = .init()
    }
    
    func syncPathStack(_ subPath: SubPath) {
        if let lastScreen = path.last, lastScreen.hasSubScreen {
            path.removeLast()
            path.append(lastScreen.update(subPath.subScreens))
        }
    }
    
    @MainActor func routeInUIKit(to screen: Screen) {
        guard let nav = navigationController else { return }
        
        
        switch screen {
        case .Second:
            let vc = SecondUIKitViewController()
            vc.title = "Second UIKit View"
            nav.pushViewController(vc, animated: true)
        case .SwiftUIRoot:
            let router = AppDelegate.main.router
            let contentView = ContentView()
                .environmentObject(router)
            let vc = CustomHostingController(rootView: contentView, router: router)
            vc.title = "SwiftUI Navigation"
            nav.pushViewController(vc, animated: true)
        case _:
            break
        }
        
        pushInUIKit(screen)
    }
    
    func pushInUIKit(_ screen: Screen) {
        path.append(screen)
        syncSubPathStack()
    }

    @MainActor func popInUIKit() {
        navigationController?.popViewController(animated: true)
        syncPathOnPop()
    }
    
    func syncPathOnPop() {
        guard !path.isEmpty else { return }
        path.removeLast()
        syncSubPathStack()
    }
    
    
    func syncPathOnPopToRoot() {
        guard !path.isEmpty else { return }
        path.removeAll()
    }
    
    @MainActor func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
        path.removeAll()
    }
    
    func syncSubPathStack() {
        if let lastScreen = path.last, let subPath = lastScreen.subPath  {
            self.subPath = subPath
        }
    }
}
