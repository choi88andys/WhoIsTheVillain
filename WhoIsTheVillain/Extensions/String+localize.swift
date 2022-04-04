//
//  File.swift
//  WhoIsTheVillain
//
//  Created by MacAndys on 2022/04/04.
//

import SwiftUI


extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}
