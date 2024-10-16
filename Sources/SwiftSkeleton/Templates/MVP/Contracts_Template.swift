//
//  Contracts_Template.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 17/09/2024.
//

import Foundation


import Foundation

class Contracts_Template : ModuleTemplate {
    
    var type : TypeFile = .contracts
    var extensions : AppExtensions?
    
    required init(module: ModuleConfiguration, projectName : String, extensions : AppExtensions? = nil) {
        self.module = module
        self.projectName = projectName
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
        
        result = result.replacingOccurrences(of: "--#presenterProtocolFileName#--",
                                             with: self.otherFileName(otherType: .presenterProtocol))
        
        result = result.replacingOccurrences(of: "--#viewProtocolFileName#--",
                                             with: self.otherFileName(otherType: .viewProtocol))
        
        result = result.replacingOccurrences(of: "--#viewModelFileName#--",
                                             with: self.otherFileName(otherType: .viewModel))
        
        result = result.replacingOccurrences(of: "--#actions#--",
                                             with: self.module.generateActions())
        
        return result
            
    }
    
}

fileprivate extension ModuleConfiguration {
    
    func generateActions() -> String {
        return self.actions?.map({$0.generatePresenterCode()}).joined(separator: "\n") ?? ""
    }
}

fileprivate extension Action {
    
    func generatePresenterCode() -> String {
        
        if destination == "back" {
            return "func handleBackAction()"
        }else{
            return "func handle\(self.Verb())Action()"
        }
    }
}

