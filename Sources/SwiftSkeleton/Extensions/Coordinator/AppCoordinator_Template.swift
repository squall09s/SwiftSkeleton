//
//  CoordinatorTemplate.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 10/10/2024.
//

import Foundation



class AppCoordinator_Template {
    
    required init(coordinatorConfiguration: CoordinatorConfiguration, projectName : String) {
        self.coordinatorConfiguration = coordinatorConfiguration
        self.projectName = projectName
    }
    
    let coordinatorConfiguration: CoordinatorConfiguration
    let projectName : String
    
    func fileName() -> String {
        return TypeFile.appCoordinator.suffixName()
    }
    
    func defaultFlow() -> String? {
        
        if let defaultFlow = self.coordinatorConfiguration.flows.first(where: { _flow in
            _flow.name == self.coordinatorConfiguration.defaultFlow
        }){
            
            return defaultFlow.name
            
        } else {
            
            return self.coordinatorConfiguration.flows.first?.name
            
        }
        
    }
    
    func export() -> String {
        
        var result = TypeFile.appCoordinator.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#enumInitialization#--",
                                             with: self.coordinatorConfiguration.generateEnum())
        
        result = result.replacingOccurrences(of: "--#defaultFlow#--",
                                             with: defaultFlow() != nil ? "showCoordinator(coordinator: .\(defaultFlow() ?? ""))" : "")
        
        
        let cases = self.coordinatorConfiguration.flows.compactMap({_flow in
            return (self.coordinatorConfiguration.initals ?? []).contains([_flow.name])  ? "case \(_flow.name)" : nil }
        ).joined(separator: "\n")
        
        result = result.replacingOccurrences(of: "--#enumCases#--",
                                             with: cases)
        
        return result
        
    }
}

fileprivate extension CoordinatorConfiguration {
    
    func generateEnum() -> String {
        return self.flows.compactMap({ _flow in
            return (self.initals ?? []).contains([_flow.name])  ?  _flow.generateEnum() : nil
        }).joined(separator: "\n")
        
    }
    
}

fileprivate extension Coordinator {
    
    func generateEnum() -> String {
        
        switch self.type {
            
        case .navigationController:
            return """
                    case .\(self.name):
                        return \(self.fileName())(navigationController: UINavigationController())
                    """
        case .tabbarController:
            return """
                    case .\(self.name):
                        return \(self.fileName())(tabBarController:  UITabBarController())
                    """
        }
        
    }
}

