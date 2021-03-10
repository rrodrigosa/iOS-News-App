//
//  String+Localizable.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/10/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
