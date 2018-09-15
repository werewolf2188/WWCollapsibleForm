//
//  WWViewRepresentation.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

public class WWViewRepresentation : NSObject {
    public var height : CGFloat = UITableViewAutomaticDimension
    private var bundle : Bundle!
    private var viewName : String!
    
    public init(view: WWItemView, height: CGFloat = UITableViewAutomaticDimension) {
        super.init()
        self.bundle = Bundle(for: type(of: view))
        self.viewName = String(describing: type(of: view))
        if (height == UITableViewAutomaticDimension) {
            self.height = self.createView().frame.size.height
        }
        else {
            self.height = height
        }
    }
    
    public init(headerFooterView: WWHeaderFooterView) {
        super.init()
        self.bundle = Bundle(for: type(of: headerFooterView))
        self.viewName = String(describing: type(of: headerFooterView))
        self.height = self.createView().frame.size.height
    }
    
    func createView() -> UIView {
        return self.bundle.loadNibNamed(self.viewName, owner: nil, options: nil)?.first as? UIView ?? UIView()
    }
}
