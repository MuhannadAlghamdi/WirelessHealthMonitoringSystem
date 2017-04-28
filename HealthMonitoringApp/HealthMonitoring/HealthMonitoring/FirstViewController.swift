//
//  ViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	@IBOutlet weak var xConstraint: NSLayoutConstraint!
	@IBOutlet weak var heartBeat: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
			self.heartBeat.frame = CGRect(x: 130, y: 131, width: 125, height: 124)
		}, completion: nil)
	}
}

extension FirstViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "heart")
	}
}
