//
//  Storyboard_Template.swift
//  SwiftSkeleton
//
//  Created by Nicolas Laurent on 26/09/2024.
//

import Foundation

class Storyboard_Template: ModuleTemplate {
    
    var type : TypeFile = .storyboard
    var extensions : AppExtensions?
    
    required init(module: ModuleConfiguration, projectName : String, extensions : AppExtensions? = nil) {
        self.module = module
        self.projectName = projectName
    }
    
    let module : ModuleConfiguration
    let projectName: String
    
    
    func fileName() -> String {
        return module.identifier() + self.type.suffixName()
    }
    
    func otherFileName(otherType: TypeFile) -> String {
        return module.identifier() + otherType.suffixName()
    }
    
    let id: String = generateStoryboardID()
    
   
    func tableViewCode(id : String) -> String {
        return """
        <tableView clipsSubviews="YES" contentMode="scaleToFill" fixedFrame="YES" alwaysBounceVertical="YES" dataMode="prototypes" style="plain" separatorStyle="default" rowHeight="-1" estimatedRowHeight="-1" sectionHeaderHeight="-1" estimatedSectionHeaderHeight="-1" sectionFooterHeight="-1" estimatedSectionFooterHeight="-1" translatesAutoresizingMaskIntoConstraints="NO" id="\(id)">
                                        <rect key="frame" x="52" y="285" width="240" height="128"/>
                                        <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                                        <color key="backgroundColor" systemColor="systemBackgroundColor"/>
                                        <connections>
                                            <outlet property="dataSource" destination="\(self.id)" id="\(generateStoryboardID())"/>
                                            <outlet property="delegate" destination="\(self.id)" id="\(generateStoryboardID())"/>
                                        </connections>
        </tableView>
        """
    }
    
    func export() -> String {
        
        
        
        var result = self.type.readTemplateFile()
        
        result = result.replacingOccurrences(of: "--#projectName#--",
                                             with: projectName)
        
        result = result.replacingOccurrences(of: "--#viewFileName#--",
                                             with: self.otherFileName(otherType: .view))
        
        
        for i in [1,2,3,4] {
            result = result.replacingOccurrences(of: "--#newIdentifier\(i)#--",
                                                 with: generateStoryboardID())
        }
        
        result = result.replacingOccurrences(of: "--#moduleIdentifier#--",
                                             with: self.module.identifier())
        
        result = result.replacingOccurrences(of: "--#id#--",
                                             with: self.id)
        
        result = result.replacingOccurrences(of: "--#actions#--",
                                             with: self.module.generateActions(storyboardID: self.id))
        
        result = result.replacingOccurrences(of: "--#storyBoardIdentifier#--",
                                             with: self.module.storyboardIdentifier())
        
        if (self.module.extensions ?? []).contains([.tableView]) {
            
            let tableViewIdIfNeeeded : String = generateStoryboardID()
            
            
            result = result.replacingOccurrences(of: "--#tableView#--",
                                                 with: self.tableViewCode(id : tableViewIdIfNeeeded))
            
            result = result.replacingOccurrences(of: "--#tableViewConnexion#--",
                                                 with: "<outlet property=\"tableView\" destination=\"\(tableViewIdIfNeeeded)\" id=\"\(generateStoryboardID())\"/>")
            
        }else{
            
            result = result.replacingOccurrences(of: "--#tableView#--",
                                                 with: "")
            
            result = result.replacingOccurrences(of: "--#tableViewConnexion#--",
                                                 with: "")
        }
        
        

        
        return result
        
    }
    
}


fileprivate func generateStoryboardID() -> String {
    
    let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
    
    func randomString(length: Int) -> String {
        return String((0..<length).map { _ in characters[Int(arc4random_uniform(UInt32(characters.count)))] })
    }
    
    let part1 = randomString(length: 3) // "XXX"
    let part2 = randomString(length: 2) // "XX"
    let part3 = randomString(length: 3) // "XXX"
    
    return "\(part1)-\(part2)-\(part3)"
}



fileprivate extension ModuleConfiguration {
    
    func generateActions(storyboardID : String) -> String {
        var i = 0
        return self.actions?.map({ (action) -> String in
            i += 1
            return action.generateXibCode(storyboardID: storyboardID, index: i)
        }).joined() ?? ""
    }
    
}

fileprivate extension Action {
    
    func generateXibCode(storyboardID : String, index : Int) -> String {
        return """

                                <button opaque="NO" contentMode="scaleToFill" fixedFrame="YES" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="system" lineBreakMode="middleTruncation" translatesAutoresizingMaskIntoConstraints="NO" id="\(generateStoryboardID())">
                                    <rect key="frame" x="10" y="\(50 + index * 50)" width="300" height="35"/>
                                    <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                                    <state key="normal" title="\(self.Verb())"/>
                                    <buttonConfiguration key="configuration" style="plain" title="\(self.Verb())"/>
                                    <connections>
                                        <action selector="button\(self.Verb())Clicked:" destination="\(storyboardID)" eventType="touchUpInside" id="\(generateStoryboardID())"/>
                                    </connections>
                                </button>

"""
    }
}
