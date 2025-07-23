//
//  SubScreen.swift
//  SampleApp
//
//  Created by bruno on 7/23/25.
//

import Foundation

struct SubPath: Hashable {
    var uuid: UUID
    var subScreens: [SubScreen]
    
    init(uuid: UUID = UUID(), subScreens: [SubScreen] = []) {
        self.uuid = uuid
        self.subScreens = subScreens
    }
    
    var isEmpty: Bool {
        self.subScreens.isEmpty
    }
    
    mutating func append(_ subScreen: SubScreen) {
        self.subScreens.append(subScreen)
    }
    
    mutating func update(_ subScreens: [SubScreen]) {
        self.subScreens = subScreens
    }
    
    mutating func removeLast() {
        self.subScreens.removeLast()
    }
    
    mutating func removeAll() {
        self.subScreens.removeAll()
    }
}
// MARK: - SubScreen Implementation
enum SubScreen: Hashable {
    case UIKitView
    case SwiftUIView
}
