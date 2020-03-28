//
//  ClockViewModel.swift
//  FNEasyBind_Example
//
//  Created by Fabio Nisci on 28/03/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FNEasyBind

class ClockViewModel {

    /// As this is a public property the value is immutable, so you can only subscribe to changes.
    var formattedDateTime: Observable<String> {
        formattedDateTimeVariable
    }
    
    /// As this is our private property the value is mutable, so only this class can modify it.
    private let formattedDateTimeVariable = Variable(ClockViewModel.formattedDate())
    
    private var timer: Timer?
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.formattedDateTimeVariable.value = ClockViewModel.formattedDate()
        })
    }
    
    private static func formattedDate() -> String {
        DateFormatter.localizedString(from: Date(),
                                      dateStyle: .none,
                                      timeStyle: .medium)
    }
}
