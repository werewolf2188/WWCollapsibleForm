//
//  WWViewInfo.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/25/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
class WWViewInfo : NSObject {
    var view: UIView!
    var height : CGFloat!
    var autoCollapse : Bool!
    var level : Int!
    
    init(view: UIView, height : CGFloat, autoCollapse : Bool, level : Int){
        super.init()
        self.view = view
        self.height = height
        self.autoCollapse = autoCollapse
        self.level = level
    }
    
    var parent : WWParentViewInfo?
}

class WWParentViewInfo : WWViewInfo {
    var children : [WWViewInfo]?
    var isCollapsed : Bool! = true
}

class WWViewInfoBuilDirector : NSObject {
    var builder: IWWViewInfoBuilder!
    
    init(builder: IWWViewInfoBuilder) {
        self.builder = builder
    }
    
    func construct (section: WWSection) {
        self.builder.section = section
    }
}

protocol IWWViewInfoBuilder : NSObjectProtocol {
    var section : WWSection! { get set }
    var dataObject : WWDataObject! { get set }
    var level : Int! { get set }
    func getResult() -> [WWViewInfo]
}

class IWWViewInfoBuilderFactory : NSObject {
    static func getBuilder(dataObject: WWDataObject) -> IWWViewInfoBuilder? {
        if dataObject is WWTemplateDataObject {
            return WWTemplateDataObjectViewInfoBuilder(dataObject:dataObject)
        } else if dataObject is WWNonTemplateDataObject {
            return WWNonTemplateDataObjectViewInfoBuilder(dataObject:dataObject)
        } else if dataObject is WWSubGroupDataObject {
            return WWSubGroupDataObjectViewInfoBuilder(dataObject:dataObject)
        }
        return nil
    }
}

fileprivate class WWTemplateDataObjectViewInfoBuilder : NSObject, IWWViewInfoBuilder{
    fileprivate var section : WWSection!
    fileprivate var dataObject : WWDataObject!
    fileprivate var level : Int!
    init(dataObject : WWDataObject) {
        super.init()
        self.dataObject = dataObject
        self.level = 0
    }
    
    func getResult() -> [WWViewInfo] {
        return [WWViewInfo(view: self.section.template.createView(), height: self.section.template.height, autoCollapse: (self.dataObject as? WWAutoCollapsable)?.autoCollapse ?? false, level: self.level)]
    }
}

fileprivate class WWNonTemplateDataObjectViewInfoBuilder : NSObject, IWWViewInfoBuilder{
    fileprivate var section : WWSection!
    fileprivate var dataObject : WWDataObject!
    fileprivate var level : Int!
    init(dataObject : WWDataObject) {
        super.init()
        self.dataObject = dataObject
        self.level = 0
    }
    
    func getResult() -> [WWViewInfo] {
        return [WWViewInfo(view: (self.dataObject as? WWNonTemplateDataObject)?.template.createView() ?? UIView(), height: (self.dataObject as? WWNonTemplateDataObject)?.template.height ?? 0, autoCollapse: (self.dataObject as? WWAutoCollapsable)?.autoCollapse ?? false, level: self.level)]
    }
}

fileprivate class WWSubGroupDataObjectViewInfoBuilder : NSObject, IWWViewInfoBuilder{
    fileprivate var section : WWSection!
    fileprivate var dataObject : WWDataObject!
    fileprivate var level : Int!
    init(dataObject : WWDataObject) {
        super.init()
        self.dataObject = dataObject
        self.level = 0
    }
    
    func getResult() -> [WWViewInfo] {
        
        let parent : WWParentViewInfo = WWParentViewInfo(view: (self.dataObject as? WWSubGroupDataObject)?.headerTemplate.createView() ?? UIView(), height: (self.dataObject as? WWSubGroupDataObject)?.headerTemplate.height ?? 0, autoCollapse: (self.dataObject as? WWAutoCollapsable)?.autoCollapse ?? false, level: self.level)
        
        var items : [WWViewInfo] = [parent]
        parent.children = []
        var builder: IWWViewInfoBuilder?
        for children in (self.dataObject as? WWSubGroupDataObject)?.data ?? [] {
            builder = IWWViewInfoBuilderFactory.getBuilder(dataObject: children)
            builder?.level = self.level + 1
            builder?.section = self.section
            let subItems : [WWViewInfo] = builder?.getResult() ?? []
            subItems.forEach({ (child) in
                child.parent = parent
            })
            parent.children?.append(contentsOf:  subItems)
            items.append(contentsOf: subItems)
        }
        return items
    }
}


