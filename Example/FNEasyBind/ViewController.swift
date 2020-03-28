//
//  ViewController.swift
//  FNEasyBind
//
//  Created by fabiosoft on 03/27/2020.
//  Copyright (c) 2020 fabiosoft. All rights reserved.
//

import UIKit
import FNEasyBind

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    private let clockViewModel = ClockViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }
    
    private func bindViews() {
        
//        clockViewModel
//            .formattedDateTime
//            .subscribe { [weak self] new, old in
//                print(new)
//        }
//        .disposed(by: &disposeBag)
        
        clockViewModel
            .formattedDateTime
            .bind(on: timeLabel, to: \.text)
            .disposed(by: &disposeBag)

    }
}

