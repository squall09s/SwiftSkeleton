//
//  NavigationControllerCoordinator_Template.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 11/10/2024.
//

import Foundation


class NavigationControllerCoordinator_Template {
    
    var childs : [ModuleConfiguration]
    var root : ModuleConfiguration
    
    required init(coordinator: Coordinator, projectName : String, root : ModuleConfiguration, childs : [ModuleConfiguration]) {
        self.coordinator = coordinator
        self.projectName = projectName
        self.childs = childs
        self.root = root
    }
    
    let coordinator: Coordinator
    let projectName : String
    
    func fileName() -> String {
        return coordinator.identifier() + TypeFile.naviationCoordinator.suffixName()
    }
    
    func export() -> String {
        
        
        var result = TypeFile.naviationCoordinator.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#fileName#--",
                                             with: self.fileName())
        
        result = result.replacingOccurrences(of: "--#rootInitialization#--",
                                             with: self.generateRootInitialization())
        
        result = result.replacingOccurrences(of: "--#childsInitialization#--",
                                             with: self.generateChildsInitialization())
        
        return result
        
    }
    
   
    func generateChildsInitialization() -> String {
        
        return self.childs.map({ (child) -> String in
            
            return """
                
            func goTo\(child.identifier())() {
                // Naviguer vers l'écran \(child.identifier())
                let model = \(child.identifier())ViewModel(title: "Login", description: "Please enter your credentials to reconnect.")
                let viewController = \(child.identifier())Builder.build(model: model, coordinator: self)
                navigationController.pushViewController(viewController, animated: true)

            }

            """
            
        }).joined()
    }
    
    
    func generateRootInitialization() -> String {
        
        return """
            
        override func start() {

            // Démarrer la navigation avec l'écran root
            let model = \(root.identifier())ViewModel(title: "Disconnected", description: "You are disconnected from the server.")
            let viewController = \(root.identifier())Builder.build(model: model, coordinator: self)
            navigationController.pushViewController(viewController, animated: false)

        }

        """
            
    }
    
}

