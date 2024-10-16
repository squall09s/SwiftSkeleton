//
//  main.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 12/09/2024.
//

import Foundation

guard CommandLine.argc > 1 else {
    print("Error : Usage: \(CommandLine.arguments[0]) <config.json>")
    exit(1)
}

let jsonFilePath = CommandLine.arguments[1] // The first argument is the path of the JSON file
let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

let generator = ProjectGenerator(jsonFileURL : jsonFileURL)
generator.generateProject()

class ProjectGenerator {
    
    let fileManager = FileManager.default
    let jsonFileURL : URL
    
    
    // Retrieve parent directory of JSON file
    func parentDirectory() -> URL {
        return jsonFileURL.deletingLastPathComponent()
    }
    
    init(jsonFileURL : URL){
        self.jsonFileURL = jsonFileURL
    }
    
    func generateProject()  {
        
        do {
            
            let jsonData = try Data(contentsOf: jsonFileURL)
            
            let decoder = JSONDecoder()
            let config = try decoder.decode(AppConfiguration.self, from: jsonData)
            
            for module in config.modules {
                
                let coordinator = config.coordinators?.flows.first(where: { _coordinator in
                    return  _coordinator.root == module.id || (_coordinator.childs ?? [] ).contains([module.id])
                })
                
                createModuleFiles(module : module, appExtensions: AppExtensions(coordinator: coordinator), projectName : config.project_name)
            }
            
            createAppCoordinatorFiles(appConfig: config)
            createCoordinatorChildsFiles(appConfig: config)
            
        } catch {
            print("Erreur lors de la lecture ou du décodage du fichier JSON: \(error)")
        }
        
    }

    func createModuleFiles(module : ModuleConfiguration, appExtensions: AppExtensions, projectName: String){
        
        var templates = [ModuleTemplate]()
        
        templates.append(ViewController_template(module: module, projectName: projectName, extensions: appExtensions))
        templates.append(Presenter_template(module: module, projectName: projectName, extensions: appExtensions))
        templates.append(Contracts_Template(module: module, projectName: projectName, extensions: appExtensions))
        templates.append(Storyboard_Template(module: module, projectName: projectName, extensions: appExtensions))
        templates.append(Builder_Template(module: module, projectName: projectName, extensions: appExtensions))
        
        for template in templates {
            
            try? fileManager.createDirectory(at: parentDirectory().appending(path: "/" + projectName + "/Sources/" + module.identifier()), withIntermediateDirectories: true)
            
            var filePath = parentDirectory().appending(path: "/" + projectName + "/Sources/\(module.identifier())/")
            filePath = filePath.appending(path: template.fileName() + template.type.fileExtension())
            
            if let data = template.export().data(using: .utf8) {
                
                do {
                    
                    //if fileManager.fileExists(atPath: filePath.path()) {
                    //    print("The file already exists, it will be replaced.")
                    //}
                    
                    // Write data to file
                    try data.write(to: filePath)
                    
                    //print("File successfully created at \(filePath)")
                } catch {
                    print("Error creating file : \(error)")
                }
            } else {
                print("Unable to convert content to UTF-8")
            }
            
        }
        
        print("Module {\(module.identifier())} created successfully (\(templates.count) files).")
        
    }


    /// EXTENSION COORDINATOR
    ///
    func createAppCoordinatorFiles(appConfig : AppConfiguration){
        
        guard let coordinator = appConfig.coordinators else {
            return
        }
        
        try? fileManager.createDirectory(at: parentDirectory().appending(path: "/" + appConfig.project_name + "/Coordinators/"), withIntermediateDirectories: true)
        
        let filePath = parentDirectory().appending(path:  "/" + appConfig.project_name + "/Coordinators/AppCoordinator.swift" )
        
        let template = AppCoordinator_Template(coordinatorConfiguration: coordinator, projectName: appConfig.project_name)
        
        if let data = template.export().data(using: .utf8) {
            
            do {
                
                //if fileManager.fileExists(atPath: filePath.path()) {
                //    print("The file already exists, it will be replaced.")
                //}
                
                // Write data to file
                try data.write(to: filePath)
                
                print("AppCordinator successfully created with \(coordinator.initals?.count ?? 0) root coordinators.")
                
            } catch {
                print("Error creating file : \(error)")
            }
        } else {
            print("Unable to convert content to UTF-8")
        }
        
        
    }


    func createCoordinatorChildsFiles(appConfig : AppConfiguration){
        
        for coordinator in appConfig.coordinators?.flows ?? [] {
            
            switch coordinator.type {
                
            case .navigationController:
                
                guard let moduleRoot = appConfig.modules.first(where: { $0.id == coordinator.root ?? "" }) else{
                    print("error 💥 : module {\(coordinator.root ?? "")} not found")
                    return
                }
                
                let modulesChilds : [ModuleConfiguration] = coordinator.childs?.compactMap({ _childID in
                    
                    let result = appConfig.modules.first(where: { $0.id == _childID })
                    
                    if result == nil {
                        print("error 💥 : child {\(_childID)} is unkwon")
                    }
                    
                    return result
                    
                    
                }) ?? []
                
                let template = NavigationControllerCoordinator_Template(coordinator: coordinator, projectName: appConfig.project_name, root: moduleRoot, childs: modulesChilds)
                
                try? fileManager.createDirectory(at: parentDirectory().appending(path: "/" + appConfig.project_name + "/Coordinators/"), withIntermediateDirectories: true)
                
                var filePath = parentDirectory().appending(path: "/" + appConfig.project_name + "/Coordinators/")
                filePath = filePath.appending(path: template.fileName() + TypeFile.naviationCoordinator.fileExtension())
                
                // Convertir le contenu en données UTF-8
                if let data = template.export().data(using: .utf8) {
                    // Écrire dans le fichier
                    do {
                        
                        //if fileManager.fileExists(atPath: filePath.path()) {
                        //print("The file already exists, it will be replaced.")
                        //}
                        
                        // Write data to file
                        try data.write(to: filePath)
                        
                        print("\(template.fileName()) successfully created (it's a navigation coordinator).")
                        
                    } catch {
                        print("Error creating file : \(error)")
                    }
                } else {
                    print("Unable to convert content to UTF-8")
                }
                
            case .tabbarController:
                
                var tabsConfigurations : [TabConfiguration] = [TabConfiguration]()
                
                for childIdentifier in coordinator.childs ?? [] {
                    
                    if childIdentifier.hasPrefix("flow:") {
                        
                        let _childIdentifier = String(childIdentifier.split(separator: ":").last!)
                        
                        if let _coordinator = appConfig.coordinators?.flows.first(where: { $0.id == _childIdentifier }){
                            tabsConfigurations.append( .coordinator(coordinator: _coordinator) )
                        }else{
                            print("error 💥 : coordinator {\(_childIdentifier)} not found")
                        }
                        
                    }else{
                        
                        print("error 💥 : TabBarCoordinator support only flow on childs")
                        
                        
                    }
                    
                }
                
                let template = TabbarControllerCoordinator_Template(coordinator: coordinator, projectName: appConfig.project_name, tabs: tabsConfigurations)
                
                try? fileManager.createDirectory(at: parentDirectory().appending(path: "/" + appConfig.project_name + "/Coordinators/"), withIntermediateDirectories: true)
                
                var filePath = parentDirectory().appending(path: "/" + appConfig.project_name + "/Coordinators/")
                filePath = filePath.appending(path: template.fileName() + TypeFile.tabBarCoordinator.fileExtension())
                
                if let data = template.export().data(using: .utf8) {
                    
                    do {
                        
                        //if fileManager.fileExists(atPath: filePath.path()) {
                        //print("The file already exists, it will be replaced.")
                        //}
                        
                        // Write data to file
                        try data.write(to: filePath)
                        
                        print("\(template.fileName()) successfully created (it's a tabbar coordinator).")
                    } catch {
                        print("Error creating file : \(error)")
                    }
                } else {
                    print("Unable to convert content to UTF-8")
                }
            }
        }
    }
    
   


}
