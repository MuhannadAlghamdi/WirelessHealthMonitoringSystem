//
//  SecondViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SecondViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "medical_report")
	}
}
