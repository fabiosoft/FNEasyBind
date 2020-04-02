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
        
        
//        let sub0 = self.clockViewModel
//            .formattedDateTime
//            .subscribe { new, old in
//                print("subito")
//                print(new)
//        }
//        //.disposed(by: &self.disposeBag)
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
//            print("disposed subito")
//            sub0.dispose()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
//            print("dopo 3 secondi")
//            
//            self.clockViewModel
//                .formattedDateTime
//                .subscribe { new, old in
//                    print("later")
//                    print(new)
//            }
//            .disposed(by: &self.disposeBag)
//            
//        }

    }
}

