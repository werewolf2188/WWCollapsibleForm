//
//  WWCollapsibleForm_UITableViewDataSource.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleFormAdapter : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].getRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: self.cellString, for: indexPath)
        cell.selectionStyle = .none
        cell.viewWithTag(self.itemTag)?.removeFromSuperview()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}
