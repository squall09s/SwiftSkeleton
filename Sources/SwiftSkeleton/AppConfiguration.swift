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
    
    func allCoordinators() -> [Coordinator] {
        var coordinators = self.coordinators?.flows ?? []
        let coordiantorsIds: [String] = coordinators.compactMap({$0.id})
                               
        // pour tous les coordinators de type tabbar
        for coordinator in coordinators.compactMap({ $0.type == .tabbarController ? $0 : nil
        })  {
            
            //on check pour tous les childs,
            for currentChildInTabBar in coordinator.childs ?? [] {
                
                if currentChildInTabBar.hasPrefix("flow:") == false && coordiantorsIds.contains([currentChildInTabBar]) == false {
                    
                    coordinators.append(Coordinator(id: currentChildInTabBar,
                                                    type: .navigationController,
                                                    root: currentChildInTabBar,
                                                    childs: []))
                    
                }
                
            }
        }
        return coordinators
    }
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
        let result = self.label.capitalized.sanitizeForSwiftKeyword()
        return result.prefix(1).capitalized + result.dropFirst()
    }

}

struct ModuleConfiguration: Codable {
    
    let id: String
    let extensions : [ModuleExtension]?
    
    let actions : [Action]?
    
    func identifier() -> String {
        let str = id
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
    
    let id: String
    let type: CoordinatorType
    let root : String?
    let childs: [String]?
    
    func identifier() -> String {
        return id.prefix(1).capitalized + id.dropFirst()
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


extension String {
    func sanitizeForSwiftKeyword() -> String {
        // Supprimer les caractères invalides
        let sanitized = self.unicodeScalars.filter { scalar in
            // Garder les lettres, chiffres et underscores
            return CharacterSet.letters.contains(scalar) ||
                   CharacterSet.decimalDigits.contains(scalar) ||
                   scalar == "_"
        }
        
        // Convertir en String
        var result = String(String.UnicodeScalarView(sanitized))
        
        // Si le premier caractère est un chiffre, ajouter un underscore devant
        if let first = result.first, first.isNumber {
            result = "_" + result
        }
        
        return result
    }
}
