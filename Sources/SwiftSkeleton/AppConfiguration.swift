//
//  AppConfiguration.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 12/09/2024.
//

import Foundation

// Définir une structure pour correspondre à la structure des données JSON (si nécessaire)
struct AppConfiguration: Codable {
    let project_name : String
    let author : String?
    let modules: [ModuleConfiguration]
    let coordinators : CoordinatorConfiguration?
}

enum ModuleExtension : String, Codable {
    case tableView
    case collectionView
}

enum ActionSender : String, Codable {
    case button
}

struct Action: Codable {
    
    let sender : ActionSender
    let destination: String?
    let label: String
    
    func Verb() -> String {
        let result = self.label.capitalized.replacingOccurrences(of: " ", with: "")
        return result.prefix(1).capitalized + result.dropFirst()
    }
}

struct ModuleConfiguration: Codable {
    
    let id: String
    let name: String?
    let extensions : [ModuleExtension]?
    
    let actions : [Action]?
    
    func identifier() -> String {
        let str = (name ?? id)
        return str.prefix(1).capitalized + str.dropFirst()
    }
    
    func storyboardIdentifier() -> String {
        return identifier() + "StoryBoardID"
    }

}

struct CoordinatorConfiguration: Codable {
    let flows: [Coordinator]
   
    let initals : [String]?
    let defaultFlow : String?
}

enum CoordinatorType : String, Codable {
    case navigationController
    case tabbarController
}

struct Coordinator : Codable {
    let name: String
    let type: CoordinatorType
    let root : String?
    let childs: [String]?
    
    func identifier() -> String {
        return name.prefix(1).capitalized + name.dropFirst()
    }
    
    func fileName() -> String {
        switch type {
        case .navigationController:
            return self.identifier() + "Coordinator"
        case .tabbarController:
            return self.identifier() + "Coordinator"
        }
    }
    
}
