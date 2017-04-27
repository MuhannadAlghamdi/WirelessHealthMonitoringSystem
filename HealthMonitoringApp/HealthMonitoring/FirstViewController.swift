//
//  ViewController.swift
//  HealthMonitoring
//
//  Created by Muhannad Alghamdi on 4/26/17.
//  Copyright © 2017 Muhannad. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
	
	@IBAction func resizeHeartBeat(_ sender: Any) {
		self.resizeImage(image: UIImage(named: "heart_beat")!, targetSize: CGSize(width: 200.0, height: 200.0))
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
 func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
	let size = image.size
	
	let widthRatio  = targetSize.width  / image.size.width
	let heightRatio = targetSize.height / image.size.height
	
	// Figure out what our orientation is, and use that to form the rectangle
	var newSize: CGSize
	if(widthRatio > heightRatio) {
		newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
	} else {
		newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
	}
	
	// This is the rect that we've calculated out and this is what is actually used below
	let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
	
	// Actually do the resizing to the rect using the ImageContext stuff
	UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
	image.draw(in: rect)
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	
	return newImage!
	}
}

extension FirstViewController: MIPivotRootPage {
	
	func imageForPivotPage() -> UIImage? {
		return UIImage(named: "heart")
	}
}
