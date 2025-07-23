//
//  Screen.swift
//  SampleApp
//
//  Created by bruno on 7/23/25.
//

import Foundation

enum Screen: Hashable {
    case Second
    case SwiftUIRoot(SubPath = .init())
    
    var hasSubScreen: Bool {
        switch self {
        case .SwiftUIRoot:
            return true
        default:
            return false
        }
    }
    
    var subPath: SubPath? {
        switch self {
        case .SwiftUIRoot(let subPath):
            return subPath
        default:
            return nil
        }
    }
    
    var subScreens: [SubScreen] {
        switch self {
        case .SwiftUIRoot(let subPath):
            return subPath.subScreens
        default:
            return []
        }
    }
    
    func update(_ subScreens: [SubScreen]) -> Screen {
        switch self {
        case .SwiftUIRoot(let subPath):
            var subPath = subPath
            subPath.update(subScreens)
            return .SwiftUIRoot(subPath)
        case .Second:
            return self
        }
    }
}
