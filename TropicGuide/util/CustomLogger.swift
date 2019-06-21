//
// Created by Vladislav Kasatkin on 2018-12-31.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import Foundation

class CustomLogger {
    static let instance = CustomLogger()

    func reportError(error: Error) {
        print(error)
    }

    func reportError(title: String, reason: String?) {
        print("\(title): \(reason ?? "no reason")")
    }
}