//
//  Template.swift
//  SwiftSkeleton
//
//  Created by Nicolas Laurent on 17/09/2024.
//

import Foundation

struct AppExtensions {
    var coordinator : Coordinator?
}

protocol ModuleTemplate {
    
    var type : TypeFile { get }
    
    init(module: ModuleConfiguration, projectName : String, extensions : AppExtensions?)

    var module : ModuleConfiguration { get }
    var extensions : AppExtensions? { get }
    
    var projectName : String { get }
    
    func fileName() -> String
    func export() -> String
    
}
