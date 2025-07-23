//
//  RootView.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.subPath.subScreens) {
            VStack(spacing: 20) {
                Text("Root View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button("UIKit View로 이동") {
                    router.push(.UIKitView)
                }
                .buttonStyle(.borderedProminent)
                
                Button("SwiftUI View로 이동") {
                    router.push(.SwiftUIView)
                }
                .buttonStyle(.bordered)
            }
            .padding()
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
    }
}

struct SwiftUIView: View {
    @EnvironmentObject var router: NavigationRouter
    var id: UUID = UUID()
    
    var body: some View {
        Text("SwiftUI View \(id)")
            .font(.largeTitle)
            .fontWeight(.bold)
            .onTapGesture {
                router.pop()
            }
        
        Button("SwiftUI View로 이동") {
            router.push(.SwiftUIView)
        }
        .buttonStyle(.borderedProminent)
        
        Button("UIKit navigation 이동") {
            router.routeInUIKit(to: .Second)
        }
        .buttonStyle(.borderedProminent)
        
        Button("Pop to Sub Root") {
            router.popToSubRoot()
        }
        .buttonStyle(.borderedProminent)
    }
}

struct UIKitView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        UIKitViewControllerRepresentable(
            title: "UIKit View",
            backgroundColor: .systemBlue.withAlphaComponent(0.1)
        )
        .navigationBarBackButtonHidden(false)
    }
}


struct UIKitViewControllerRepresentable: UIViewControllerRepresentable {
    let title: String
    let backgroundColor: UIColor
    
    func makeUIViewController(context: Context) -> SampleUIKitViewController {
        return SampleUIKitViewController(title: title, backgroundColor: backgroundColor)
    }
    
    func updateUIViewController(_ uiViewController: SampleUIKitViewController, context: Context) {
    }
}

class SampleUIKitViewController: UIViewController {
    
    private let titleText: String
    private let backgroundColor: UIColor
    
    init(title: String, backgroundColor: UIColor = .systemBackground) {
        self.titleText = title
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = backgroundColor
        
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
