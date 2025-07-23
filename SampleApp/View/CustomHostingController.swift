//
//  CustomHostingController.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import UIKit
import SwiftUI

// MARK: - Custom Hosting Controller for SwiftUI
class CustomHostingController<Content: View>: UIHostingController<Content>, UIGestureRecognizerDelegate {
    
    private weak var router: NavigationRouter?
    
    init(rootView: Content, router: NavigationRouter) {
        self.router = router
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInteractivePopGesture()
    }
    
    private func setupInteractivePopGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return router?.isEmptySubPath ?? false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
