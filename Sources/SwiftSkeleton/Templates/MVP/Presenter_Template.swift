//
//  Presenter_Template.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 17/09/2024.
//

import Foundation

class Presenter_template : ModuleTemplate {
    
    var type : TypeFile = .presenter
    var extensions : AppExtensions?
    
    required init(module: ModuleConfiguration, projectName : String, extensions : AppExtensions? = nil) {
        self.module = module
        self.projectName = projectName
        self.extensions = extensions
    }
    
    let module : ModuleConfiguration
    let projectName: String
    
    func fileName() -> String {
        return module.identifier() + self.type.suffixName()
    }
    
    func otherFileName(otherType: TypeFile) -> String {
        return module.identifier() + otherType.suffixName()
    }
    
    func export() -> String {
        
        var extensionCoordinator : String = ""
        
        if let extensions, let coordinator = extensions.coordinator {
            if case .navigationController = coordinator.type {
                extensionCoordinator = "weak var coordinator : \(coordinator.fileName())?"
            }
        }
        
        var result = self.type.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#fileName#--",
                                             with: self.fileName())
        
        result = result.replacingOccurrences(of: "--#presenterProtocolFileName#--",
                                             with: self.otherFileName(otherType: .presenterProtocol))
        
        result = result.replacingOccurrences(of: "--#viewProtocolFileName#--",
                                             with: self.otherFileName(otherType: .viewProtocol))
        
        result = result.replacingOccurrences(of: "--#viewModelFileName#--",
                                             with: self.otherFileName(otherType: .viewModel))
        
        result = result.replacingOccurrences(of: "--#coordinator#--",
                                             with: extensionCoordinator)
        
        result = result.replacingOccurrences(of: "--#actions#--",
                                             with: self.module.generateActions())
        
        return result
        
    }
    
}



fileprivate extension ModuleConfiguration {
    
    func generateActions() -> String {
        return self.actions?.map({$0.generatePresenterCode()}).joined(separator: "\n\n") ?? ""
    }
    
}

fileprivate extension Action {
    
    func generatePresenterCode() -> String {
        
        if let destination {
            
            if destination.hasPrefix("flow") {
                
                
                var destinationID = destination.replacingOccurrences(of: "flow:", with: "")
                destinationID = destinationID.prefix(1).capitalized + destinationID.dropFirst()
                
                return
"""
        func handle\(self.Verb())Action() {
            self.coordinator?.navigate(to: \(destinationID)Coordinator())
        }
"""
            }else if destination == "back"{
                
                return
"""
                func handle\(self.Verb())Action() {
                    self.coordinator?.back()
                }
"""
                
            }else{
                
                let destinationID = destination.prefix(1).capitalized + destination.dropFirst()
                return
    """
            func handle\(self.Verb())Action() {
                self.coordinator?.goTo\(destinationID)()
            }
    """
            
            }
            
            
        }else{
            
            return
"""
         func handle\(self.Verb())Action() {
         }
"""
        }
    }
}
