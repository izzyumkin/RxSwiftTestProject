//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by Иван Изюмкин on 13.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var firstMessageLabel: UILabel!
    
    private var messages = BehaviorRelay(value: ["Hello i am Ann"])
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.asObservable()
            .debug()
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .filter({ value in
                value.count > 1
            }).map({ value in
                value.joined(separator: ",\n")
            }).subscribe(onNext: { [weak self] value in
                
                self?.firstMessageLabel.text = value
                
            }).disposed(by: bag)
        
        messages.accept(["How are you?", "What would you like to do today?", "Your subscription ends in a month!!!"])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.messages.accept(["How do you like your new job?"])
        }
        
    }


}

