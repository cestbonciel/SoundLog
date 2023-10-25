//
//  SharedDelegate.swift
//  UserLocationAddress
//
//  Created by Seohyun Kim on 2023/10/23.
//

import Foundation

protocol MapViewControllerDelegate: AnyObject {
	 func didSelectLocationWithAddress(_ address: String?)
	 func dismissMapViewController()
}
