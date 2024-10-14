//
//  TabbatrControllerCoordinator_Template.swift
//  SwiftSkeleton
//
//  Created by Nicolas Laurent on 11/10/2024.
//

import Foundation

enum TabConfiguration {
    case module(module : ModuleConfiguration)
    case coordinator(coordinator : Coordinator)
}

class TabbarControllerCoordinator_Template {
    
    var tabs : [TabConfiguration]
    
    required init(coordinator: Coordinator, projectName : String, tabs : [TabConfiguration]) {
        self.coordinator = coordinator
        self.projectName = projectName
        self.tabs = tabs
    }
    
    let coordinator: Coordinator
    let projectName : String
    
    func fileName() -> String {
        return coordinator.identifier() + TypeFile.tabBarCoordinator.suffixName()
    }
    
    func export() -> String {
        
        var result = TypeFile.tabBarCoordinator.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#fileName#--",
                                             with: self.fileName())
        
        result = result.replacingOccurrences(of: "--#tabsDeclarations#--",
                                             with: self.generateTabsDeclarations())
        
        result = result.replacingOccurrences(of: "--#tabsInitialization#--",
                                             with: self.generateTabsInitialization())
        
        result = result.replacingOccurrences(of: "--#tabsAssignment#--",
                                             with: self.generateTabsAssignment())
        
        return result
        
    }
  
    func generateTabsDeclarations() -> String {
        
        return self.tabs.map({ (tab) -> String in
            
            switch tab {
                
            case .module(let module):
                return "var tab\(module.identifier()): \(module.identifier())ViewController?"
                
            case .coordinator(let coordinator):
                return "var tab\(coordinator.identifier()): \(coordinator.fileName())?"
            }
        
        }).joined(separator: "\n")
            
    }
  
    func generateTabsInitialization() -> String {
        
        var i = -1
        
        return self.tabs.map({ (tab) -> String in
            
            i += 1
            
            switch tab {
                
            case .module(let module):
                
                return """
        
                let _tab\(module.identifier()) = \(module.identifier())Builder.build(model: \(module.identifier())ViewModel(title: "", description: ""))
                _tab\(module.identifier()).tabBarItem = UITabBarItem(title: _tab\(module.identifier()).title, image: UIImage(systemName: "heart.circle.fill"), tag: \(i))
                    
                tab\(module.identifier()) = _tab\(module.identifier())
    """
                
            case .coordinator(let coordinator):
                
                return """
        
                  tab\(coordinator.identifier()) = \(coordinator.fileName())(navigationController: UINavigationController())
                  tab\(coordinator.identifier())?.navigationController = UINavigationController()
                  tab\(coordinator.identifier())?.start()
                  tab\(coordinator.identifier())?.rootViewController()?.tabBarItem = UITabBarItem(title: tab\(coordinator.identifier())?.rootViewController()?.title ?? "", image: UIImage(systemName: "heart.circle.fill"), tag: \(i))
    """
            }
            
        }).joined()
    }
    
    
    
    func generateTabsAssignment() -> String {
        
        return self.tabs.map({ (tab) -> String in
            
            switch tab {
            case .module(let module):
                return "tab\(module.identifier())"
            case .coordinator(let coordinator):
                return "tab\(coordinator.identifier())?.rootViewController()"
            }
            
        }).joined(separator: ",")
            
    }
    
}


