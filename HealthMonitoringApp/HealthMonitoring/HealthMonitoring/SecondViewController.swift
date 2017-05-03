//
//  SecondViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit
import Charts

class SecondViewController: UIViewController {

	@IBOutlet weak var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }		
}

extension SecondViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "medical_report")
	}
}
