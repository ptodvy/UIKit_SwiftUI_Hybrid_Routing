# UIKit과 SwiftUI 하이브리드 라우팅 전략

---

## 📋 개요

UIKit과 SwiftUI를 함께 사용하는 하이브리드 앱에서 효과적인 네비게이션을 위한 라우팅 전략입니다.

### 🔍 구조

```
UIKit → UIHostingController → SwiftUI NavigationStack → SwiftUI View or UIViewControllerRepresentable
```

---

## 🏗️ 하이브리드 라우팅 아키텍처

### 📊 전체 구조

```
UIKit 베이스 + SwiftUI 서브 스택
├── UIKit 메인 스택 (UINavigationController)
│   ├── RootUIKitViewController
│   ├── SecondUIKitViewController  
│   └── CustomHostingController (SwiftUI 래퍼)
└── SwiftUI 서브 스택 (NavigationStack)
    ├── ContentView
    ├── SwiftUIView
    └── UIKitView (UIViewControllerRepresentable)
```

### 🧱 핵심 컴포넌트

#### **1. 분리된 스택 관리**
```swift
class NavigationRouterImpl: NavigationRouter, ObservableObject {
    // UIKit 메인 스택 (실제 화면 표시)
    private var path: [Screen] = []
    
    // SwiftUI 서브 스택 (SwiftUI 내부 네비게이션)
    @Published var navigationPath: [SubScreen] = [] {
        didSet {
            syncPathStack()  // 자동 동기화
        }
    }
}
```

#### **2. 타입 안전한 화면 정의**
```swift
enum Screen {
    case Second
    case SwiftUIRoot([SubScreen] = [])
    
    func update(_ subScreens: [SubScreen]) -> Screen {
        switch self {
        case .SwiftUIRoot:
            return .SwiftUIRoot(subScreens)
        case .Second:
            return self
        }
    }
}

enum SubScreen {
    case UIKitView
    case SwiftUIView
}
```

#### **3. 스마트 라우팅**
```swift
func push(_ screen: SubScreen) {
    navigationPath.append(screen)
    // didSet에서 자동으로 syncPathStack() 호출
}

func syncPathStack() {
    if let lastScreen = path.last {
        path.removeLast()
        path.append(lastScreen.update(navigationPath))
    }
}
```

---

## 💻 코드 적용 예시

### CustomHostingController
```swift
public class CustomHostingController<Content: View>: UIHostingController<Content> {
    private weak var router: NavigationRouterImpl?
    
    // 라우터 설정
    public func setRouter(_ router: NavigationRouterImpl) {
        self.router = router
    }
}
```

### SwiftUI NavigationStack
```swift
NavigationStack(path: $router.navigationPath) {
    ContentView()
        .navigationDestination(for: SubScreen.self) { screen in
            switch screen {
            case .UIKitView:
                UIKitView()
            case .SwiftUIView:
                SwiftUIView()
            }
        }
}
.environmentObject(router)
```

---

## 🎯 하이브리드 라우팅의 장점

### ✅ **명확한 책임 분리**
- **UIKit**: 메인 네비게이션 스택 관리
- **SwiftUI**: 서브 네비게이션 스택 관리
- **Router**: 두 스택 간의 동기화

### ✅ **타입 안전성**
- enum 기반 타입 시스템으로 컴파일 타임 에러 방지
- 런타임 에러 최소화

### ✅ **자동 동기화**
- `didSet`을 통한 상태 자동 동기화
- 수동 동기화 불필요

### ✅ **확장성**
- 새로운 화면 타입 추가 시 `update()` 메서드만 구현
- 기존 로직 수정 없이 확장 가능

---

## ⚖️ 장점 vs 주의점

### ✅ 장점

* UIKit와 SwiftUI 간 경계가 명확해지며 간단함
* 각 스택의 독립성 보장
* 타입 안전성으로 런타임 에러 방지
* 자동 동기화로 개발 복잡성 최소화

### ⚠️ 주의점

* 두 스택 관리의 복잡성
* 상태 동기화 로직의 정확성 필요
* 디버깅 시 두 스택 상태 모두 확인 필요

---

## 📌 설계 원칙

| 원칙                                                      | 설명                                       |
| ------------------------------------------------------- | ---------------------------------------- |
| 라우터는 상태만 관리, UI는 UI가 결정                                 | VC 생성은 외부 팩토리에서                          |
| 각 스택은 독립적으로 관리하되 동기화 필요                                         | SwiftUI 스택 변경 시 UIKit 스택 자동 업데이트 |
| NavigationStack과 navigationController는 각각의 역할에 집중 | UIKit은 메인, SwiftUI는 서브 역할 명확화                            |

---

## 🔗 참고 링크

- [UINavigationController Documentation](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
- [NavigationStack Documentation](https://developer.apple.com/documentation/swiftui/navigationstack)

---

## 🚀 결론

하이브리드 라우팅 전략을 통해 UIKit과 SwiftUI의 네비게이션을 효과적으로 관리할 수 있습니다. 

**핵심은 분리된 스택 관리와 자동 동기화**이며, 이를 통해:
- 개발 복잡성 최소화
- 확장 가능한 아키텍처 구축
- 타입 안전성 보장

이 전략은 UIKit 베이스 앱에서 SwiftUI를 점진적으로 도입할 때 매우 유용한 접근법입니다.

---

---

# UIKit and SwiftUI Hybrid Routing Strategy

---

## 📋 Overview

A routing strategy for effective navigation in hybrid apps that use UIKit and SwiftUI together.

### 🔍 Structure

```
UIKit → UIHostingController → SwiftUI NavigationStack → SwiftUI View or UIViewControllerRepresentable
```

---

## 🏗️ Hybrid Routing Architecture

### 📊 Overall Structure

```
UIKit Base + SwiftUI Sub Stack
├── UIKit Main Stack (UINavigationController)
│   ├── RootUIKitViewController
│   ├── SecondUIKitViewController  
│   └── CustomHostingController (SwiftUI Wrapper)
└── SwiftUI Sub Stack (NavigationStack)
    ├── ContentView
    ├── SwiftUIView
    └── UIKitView (UIViewControllerRepresentable)
```

### 🧱 Core Components

#### **1. Separated Stack Management**
```swift
class NavigationRouterImpl: NavigationRouter, ObservableObject {
    // UIKit main stack (actual screen display)
    private var path: [Screen] = []
    
    // SwiftUI sub stack (SwiftUI internal navigation)
    @Published var navigationPath: [SubScreen] = [] {
        didSet {
            syncPathStack()  // automatic synchronization
        }
    }
}
```

#### **2. Type-Safe Screen Definition**
```swift
enum Screen {
    case Second
    case SwiftUIRoot([SubScreen] = [])
    
    func update(_ subScreens: [SubScreen]) -> Screen {
        switch self {
        case .SwiftUIRoot:
            return .SwiftUIRoot(subScreens)
        case .Second:
            return self
        }
    }
}

enum SubScreen {
    case UIKitView
    case SwiftUIView
}
```

#### **3. Smart Routing**
```swift
func push(_ screen: SubScreen) {
    navigationPath.append(screen)
    // syncPathStack() automatically called in didSet
}

func syncPathStack() {
    if let lastScreen = path.last {
        path.removeLast()
        path.append(lastScreen.update(navigationPath))
    }
}
```

---

## 💻 Code Implementation Example

### CustomHostingController
```swift
public class CustomHostingController<Content: View>: UIHostingController<Content> {
    private weak var router: NavigationRouterImpl?
    
    // Router setup
    public func setRouter(_ router: NavigationRouterImpl) {
        self.router = router
    }
}
```

### SwiftUI NavigationStack
```swift
NavigationStack(path: $router.navigationPath) {
    ContentView()
        .navigationDestination(for: SubScreen.self) { screen in
            switch screen {
            case .UIKitView:
                UIKitView()
            case .SwiftUIView:
                SwiftUIView()
            }
        }
}
.environmentObject(router)
```

---

## 🎯 Benefits of Hybrid Routing

### ✅ **Clear Responsibility Separation**
- **UIKit**: Main navigation stack management
- **SwiftUI**: Sub navigation stack management
- **Router**: Synchronization between two stacks

### ✅ **Type Safety**
- Enum-based type system prevents compile-time errors
- Minimizes runtime errors

### ✅ **Automatic Synchronization**
- Automatic state synchronization through `didSet`
- No manual synchronization required

### ✅ **Scalability**
- Only implement `update()` method when adding new screen types
- Extensible without modifying existing logic

---

## ⚖️ Advantages vs Considerations

### ✅ Advantages

* Clear boundaries between UIKit and SwiftUI make it simple
* Ensures independence of each stack
* Type safety prevents runtime errors
* Automatic synchronization minimizes development complexity

### ⚠️ Considerations

* Complexity of managing two stacks
* Accuracy of state synchronization logic required
* Need to check both stack states when debugging

---

## 📌 Design Principles

| Principle                                                      | Description                                       |
| ------------------------------------------------------- | ---------------------------------------- |
| Router only manages state, UI decides UI                                 | VC creation handled by external factory                          |
| Each stack is managed independently but synchronization is required                                         | UIKit stack automatically updates when SwiftUI stack changes |
| NavigationStack and navigationController focus on their respective roles | Clear role definition: UIKit for main, SwiftUI for sub                            |

---

## 🔗 Reference Links

- [UINavigationController Documentation](https://developer.apple.com/documentation/uikit/uinavigationcontroller)
- [NavigationStack Documentation](https://developer.apple.com/documentation/swiftui/navigationstack)

---

## 🚀 Conclusion

The hybrid routing strategy enables effective navigation management between UIKit and SwiftUI.

**The key is separated stack management and automatic synchronization**, which enables:
- Minimized development complexity
- Scalable architecture
- Type safety guarantee

This strategy is a very useful approach when gradually introducing SwiftUI into UIKit-based apps.

