//
//  ViewController_Template.swift
//  SwiftSkeleton
//
//  Created with enthusiasm 😺 on 12/09/2024.
//

import Foundation


class ViewController_template : ModuleTemplate {
    
    var type : TypeFile = .view
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
        
        var result = self.type.readTemplateFile()

        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#fileName#--",
                                             with: self.fileName())
        
        result = result.replacingOccurrences(of: "--#presenterProtocolFileName#--",
                                             with: self.otherFileName(otherType: .presenterProtocol))
        
        result = result.replacingOccurrences(of: "--#viewProtocolFileName#--",
                                             with: self.otherFileName(otherType: .viewProtocol))
        
        result = result.replacingOccurrences(of: "--#actions#--",
                                             with: self.module.generateActions())
        
     
        if (self.module.extensions ?? []).contains([.tableView]) {
            
            result = result.replacingOccurrences(of: "--#tableViewDeclaration#--",
                                                 with:  "@IBOutlet weak var tableView: UITableView!")
            
            result = result.replacingOccurrences(of: "--#tableViewCellRegister#--",
                                                 with:  "//self.tableView.register(UINib(nibName: \"CustomTableViewCell\", bundle: nil), forCellReuseIdentifier: \"CustomTableViewCell\")")
           
            result = result.replacingOccurrences(of: "--#tableViewExtension#--",
                                                 with: self.tableViewExtension())
        }else{
            
            result = result.replacingOccurrences(of: "--#tableViewDeclaration#--",
                                                 with: "")
            
            result = result.replacingOccurrences(of: "--#tableViewCellRegister#--",
                                                 with:  "")
           
            result = result.replacingOccurrences(of: "--#tableViewExtension#--",
                                                 with: "")
            
        }
        
        
        return result
        
        
    }
    
    
    func tableViewExtension() -> String {
        
        return """
        
        extension \(self.fileName()) : UITableViewDelegate, UITableViewDataSource {
            
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 10
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                //let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath)
                let cell = UITableViewCell(style: .default, reuseIdentifier: "CustomTableViewCell")
                
                var content = cell.defaultContentConfiguration()

                // Configure content.
                content.text = "Test"

                // Customize appearance.
                content.imageProperties.tintColor = .purple

                
                return cell
            }
        }

        """
    }
}


fileprivate extension ModuleConfiguration {
    
    func generateActions() -> String {
        return (self.actions ?? []).map({$0.generateControllerCode()}).joined(separator: "\n")
    }
    
}

fileprivate extension Action {
    
    func generateControllerCode() -> String {
        
        
            
            return
    """
        @IBAction func button\(self.Verb())Clicked(_ sender: UIButton) {
            self.presenter?.handle\(self.Verb())Action()
        }
    """
          
        
    }
}
