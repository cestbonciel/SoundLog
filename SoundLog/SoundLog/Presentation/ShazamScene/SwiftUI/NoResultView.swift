//
//  NoResultView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//

import SwiftUI

struct NoResultView: View {
	var buttonAction: () -> Void
	
	 var body: some View {
		 VStack(alignment: .center, spacing: 12) {
			 
			 Image(systemName: "headphones.circle")
				 .font(.system(size: 40, weight: .light))
				 .foregroundColor(Color.black.opacity(0.8))
			 Text("노래를 찾을 수 없어요.")
				 .font(.headline)
				 .foregroundColor(Color.black.opacity(0.8))
			 
			 Spacer()
				 .frame(width: 20,height:48)
			 Button(
				action: { buttonAction() },
				label: {
					Text("다시 탐색")
						.font(.system(size: 14, weight: .bold, design: .default))
						.foregroundColor(.white)
						.frame(width: 200, height: 48, alignment: .center)
						.background(
							RoundedRectangle(cornerRadius: 24).fill(Color.init(uiColor: .neonPurple)).shadow(radius: 1)
						)
					
				})
			 
		 }
	 }
}

struct NoResultView_Previews: PreviewProvider {
	 static var previews: some View {
		 NoResultView(buttonAction: {})
	 }
}

