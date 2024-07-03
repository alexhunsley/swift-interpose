//
//  Date.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 03/07/2024.
//

import Foundation

extension Interpose {
    public typealias FormattedDateProvider = () -> String

    // should we protect this like we do the logger and assertion failure stuff?
    // we protect them because we want to decorate stuff that they are called with,
    // but we're not decorating here...
    public static let defaultDateProvider: FormattedDateProvider = {
        "\(Date())"
    }

    public static let mockDateProvider: FormattedDateProvider = {
        "[Date mock]"
    }

    public static var dateProvider: FormattedDateProvider = Interpose.defaultDateProvider
}
