//
//  Builder_Template.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 01/10/2024.
//

import Foundation


class Builder_Template: ModuleTemplate {
    
    var type : TypeFile = .builder
    var extensions : AppExtensions?
    
    required init(module: ModuleConfiguration, projectName : String, extensions : AppExtensions? = nil) {
        self.module = module
        self.projectName = projectName
        self.extensions = extensions
    }
    
    let module : ModuleConfiguration
    let projectName : String
    
    func fileName() -> String {
        return module.identifier() + self.type.suffixName()
    }
    
    func otherFileName(otherType: TypeFile) -> String {
        return module.identifier() + otherType.suffixName()
    }
    
    
    
    func export() -> String {
    
        var result = self.type.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#fileName#--",
                                             with: self.fileName())
        
        result = result.replacingOccurrences(of: "--#viewModelFileName#--",
                                             with: self.otherFileName(otherType: .viewModel))
        
        result = result.replacingOccurrences(of: "--#extensionCoordinator#--",
                                             with: self.extensionCoordinator())
        
        result = result.replacingOccurrences(of: "--#viewFileName#--",
                                             with: self.otherFileName(otherType: .view))
        
        result = result.replacingOccurrences(of: "--#storyboardFileName#--",
                                             with: self.otherFileName(otherType: .storyboard))
        
        result = result.replacingOccurrences(of: "--#presenterFileName#--",
                                             with: self.otherFileName(otherType: .presenter))
        
        result = result.replacingOccurrences(of: "--#storyboardIdentifier#--",
                                             with: self.module.storyboardIdentifier())
        
       
        if extensions?.coordinator?.type == .navigationController  {
            
            result = result.replacingOccurrences(of: "--#coordinator_assignation#--",
                                                 with: "presenter.coordinator = coordinator")
            
        }else{
            
            result = result.replacingOccurrences(of: "--#coordinator_assignation#--",
                                                 with: "//presenter.coordinator = coordinator")
            
        }
    
        
        return result

        
    }
    
    fileprivate func extensionCoordinator() -> String {
        
        var extensionCoordinator : String = ""
        
        if let extensions, let coordinator = extensions.coordinator {
            if case .navigationController = coordinator.type {
                extensionCoordinator = ", coordinator: \(coordinator.fileName())"
            }
        }
        
        return extensionCoordinator
    }
    
}


