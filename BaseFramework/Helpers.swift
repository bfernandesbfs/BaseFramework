//
//  Helpers.swift
//  BaseFramework
//
//  Created by Bruno Fernandes on 30/10/15.
//  Copyright © 2015 Bruno Fernandes. All rights reserved.
//

import Foundation

let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)

public var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = NSLocale.currentLocale()
    formatter.timeZone = NSTimeZone.systemTimeZone()
    return formatter
}()

extension String {
    
    func quote(mark: Character = "\"") -> String {
        let escaped = characters.reduce("") { string, character in
            string + (character == mark ? "\(mark)\(mark)" : "\(character)")
        }
        return "\(mark)\(escaped)\(mark)"
    }
}
