//
//  ShazamHostingController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//

import UIKit
import SwiftUI

final class ShazamHostingController: UIHostingController <ContentView> {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder, rootView: ContentView())
	}
}
