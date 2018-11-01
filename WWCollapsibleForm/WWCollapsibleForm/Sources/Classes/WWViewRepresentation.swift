//
//  WWViewRepresentation.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class represents a template of a view that will be use during the creation of an item, header or selected header. This only contains the basic information needed for the view to be created.
public class WWViewRepresentation : NSObject {
    /// The height of the template. This has to be greater than zero or an automatic dimension.
    public var height : CGFloat = UITableViewAutomaticDimension
    private var bundle : Bundle!
    private var viewName : String!
    
    /// Instantiates a template based on a view that subclass `WWItemView` with a specific height.
    /// - Parameter view: An instance of a view that can be used as a template.
    /// - Parameter height: The height that will be used for that view.
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
    
    /// Instantiates a template based on a view that subclass `WWHeaderView`. It will take the height of the view used in a nib.
    /// - Parameter headerView: An instance of a view that can be used as a template of the header.
    public init(headerView: WWHeaderView) {
        super.init()
        self.bundle = Bundle(for: type(of: headerView))
        self.viewName = String(describing: type(of: headerView))
        self.height = self.createView().frame.size.height
    }
    
    func createView() -> UIView {
        return self.bundle.loadNibNamed(self.viewName, owner: nil, options: nil)?.first as? UIView ?? UIView()
    }
}
