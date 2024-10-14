//
//  TypeFile.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 10/10/2024.
//

import Foundation


enum TypeFile {
    
    case view
    case presenter
    case presenterProtocol
    case viewProtocol
    case contracts
    case viewModel
    case storyboard
    case builder
    case appCoordinator
    case tabBarCoordinator
    case naviationCoordinator
    
    func suffixName() -> String {
        
        switch self {
        case .view :
            return "ViewController"
        case .presenter :
            return "Presenter"
        case .presenterProtocol :
            return "PresenterProtocol"
        case .viewProtocol :
            return "ViewProtocol"
        case .contracts :
            return "Contracts"
        case .viewModel :
            return "ViewModel"
        case .storyboard :
            return "Storyboard"
        case .builder :
            return "Builder"
        case .appCoordinator:
            return "AppCoordinator"
        case .naviationCoordinator, .tabBarCoordinator:
            return "Coordinator"
        }
        
    }
    
    func ressourceFileName() -> String {
        
        switch self {
        
        case .naviationCoordinator:
            return "NavigationControllerCoordinator"
        case .tabBarCoordinator:
            return "TabBarControllerCoordinator"
        default :
            return suffixName()
        }
        
    }
    
    func fileExtension() -> String {
        switch self {
            
        case .storyboard:
            return ".storyboard"
        default:
            return ".swift"
        }
        
    }
    
    func readTemplateFile() -> String {
        
        if let fileURL = Bundle.module.url(forResource: self.ressourceFileName(), withExtension: "txt") {
            do {
                // Lire le contenu du fichier texte
                let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
                return fileContents
            } catch {
                print("Erreur lors de la lecture du fichier texte : \(error)")
                return ""
            }
        } else {
            print("Le fichier \(self.ressourceFileName()) est introuvable dans le bundle.")
            return ""
        }
        
    }
}
