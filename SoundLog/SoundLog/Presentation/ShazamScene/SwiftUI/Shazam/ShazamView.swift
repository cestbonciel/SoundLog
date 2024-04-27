//
//  ShazamView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//
import Combine
import SwiftUI

struct ShazamView: View {
	@State private var shouldShowAnimationView = false
	@State private var shouldShowRecordButton = false
	@State private var shouldShowInfoAlert = false
	@State private var shouldShowRecordPermissionAlert = false
	@State private var shouldShowNoResultView = false
    @State private var shouldShowInfoText = true
    @State private var shouldShowCancelButton = false
	@State private var foundSong: SongData!
	@State private var cancellables: Set<AnyCancellable> = []
	@EnvironmentObject private var shazamViewModel: ShazamViewModel

  
    
	@State var isAnimating: Bool = false
    //@State private var foundSong2 = SongData.example()
	
	
	 var body: some View {
		 ZStack {
			 Color.init(.pastelSkyblue)
			 
			 ZStack {
				 
				 VStack(spacing: 20) {
                     
                     if shouldShowAnimationView {
                         ZStack {
                             RippleView(
                                style: .solid,
                                rippleCount: 5,
                                tintColor: Color.slneonPurple,
                                timeIntervalBetweenRipples: 0.18
                             )
                             .padding(.horizontal, 48)
                             .zIndex(0) // RippleView를 zIndex 0으로 설정합니다.
                             
                             // cancelButton이 zIndex 1로 설정되어 RippleView 위에 위치합니다.
                             
                             cancelButton
                                 .zIndex(1)
                                 .padding(.top, 24) // 상단에서 16 포인트 떨어지도록
                                 .padding(.trailing, 8) // 오른쪽에서 16 포인트 떨어지도록
                                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                             
                         }
                     }
                     
                    
					 if shouldShowNoResultView {
						 NoResultView {
							 onRecordButtonTapped()
						 }
					 }
                   
                     if shouldShowInfoText {
                         infoTextView
                     }
					 if shouldShowRecordButton {
						 recordButton
							 .alert(isPresented: $shouldShowRecordPermissionAlert, content: {
								 permissionAlert
							 })
					 }

                     
                     if foundSong != nil {
                         VStack {
                             ZStack(alignment: .topTrailing) {
                                 SongDetail(song: foundSong)
                                     .animation(.easeInOut, value: isAnimating)
                                     .padding(.top, 64) // Padding on top of SongDetail

                                 resetButton
                                     .padding(.trailing, 8) // Right padding for alignment
                                     .padding(.top, 16) // Padding from the top of the ZStack
                             }

                             Spacer() // Pushes all content to the top

                             recordButton
                                 .padding(.bottom, 48) // Padding from the bottom of the VStack
                         }
                         //.padding(.vertical, 56)
                     }
    
					 
				 }
				 
			 }// : ZSTACK
             .padding(EdgeInsets(top: 16, leading: 0, bottom: 24, trailing: 0))
			 //.padding(EdgeInsets(top: 24, leading: 0, bottom: 24, trailing: 0))
             
		 }
         .onAppear(perform: { bindViewModel() })
		 .onDisappear(perform: { shazamViewModel.stopListening() })
		 .ignoresSafeArea()
	 }
	

	private var permissionAlert: Alert {
		 Alert(
			  title: Text("마이크 사용 접근을 허용하지 않았습니다."),
			  message: Text("마이크를 켜고 주변음을 탐색하세요."),
			  primaryButton: .default(
					Text("설정으로 가기"),
					action: {
						 goToPermissionSettings()
					}
			  ),
			  secondaryButton: .cancel(Text("닫기"))
		 )
	}


	@ViewBuilder
	private var recordButton: some View {
		 Button(action: {
			  onRecordButtonTapped()
             //shazamViewModel.toggleShazam()
		 }, label: {
			  Image(systemName: "music.note")
					.font(.system(size: 48, weight: .bold))
					//.foregroundColor(.white)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.slRealBlue, .slneonPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
					.frame(width: 100, height: 100, alignment: .center)
					.background(
                        Circle().fill(Color.black)
							  .shadow(radius: 1)
					)
		 })
         .padding(.bottom, 48)
	}
    
    @ViewBuilder
    private var infoTextView: some View {
        VStack {
            Text("Shazam 검색")
                .font(.custom("GmarketSansTTFBold", size: 16))
            Text("주변 소음이 없는 곳에서\n 음악만 녹음해주세요.")
                .font(.custom("GmarketSansTTFMedium", size: 14))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(16)
                .foregroundColor(Color.slRealBlue)
        }
        .padding(.vertical, 24)
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        HStack {
            Spacer()
            Button {
                cancelShazamSearch()
            } label: {
                HStack {
                    Image("xButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    Text("취소")
                        .font(.custom("Pretendard-Medium", size: 16))
                }
                .frame(width: 80, height: 32)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .background(Color.slneonPurple.opacity(0.5))
                .foregroundColor(.black)
                .cornerRadius(16)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    @ViewBuilder
    private var resetButton: some View {
        HStack {
            Spacer()
            Button {
                cancelShazamSearch()
            } label: {
                HStack {
                    Image("xButton_White")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                    Text("초기화")
                        .font(.custom("Pretendard-Medium", size: 13))
                }
                .frame(width: 80, height: 32)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
                .background(Color.slRealBlue)
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    private func cancelShazamSearch() {
        shazamViewModel.stopListening()
        resetToInitialState()
    }
    
    private func resetToInitialState() {
        shouldShowAnimationView = false
        shouldShowInfoText = true
        shouldShowRecordButton = true
        shouldShowNoResultView = false
        
        foundSong = nil
    }
    
    private func bindViewModel() {
        shazamViewModel.$viewState.sink { viewState in
            switch viewState {
            case .initial:
                shouldShowInfoText = true
                shouldShowAnimationView = false
                shouldShowRecordButton = true
                shouldShowNoResultView = false
            case .recordingInProgress:
                shouldShowInfoText = false
                shouldShowRecordButton = false
                shouldShowAnimationView = true
                shouldShowNoResultView = false
                foundSong = nil

            case .recordPermissionSettingsAlert:
                shouldShowRecordPermissionAlert = true
            case .noResult:
                shouldShowInfoText = false
                shouldShowAnimationView = false
                shouldShowRecordButton = false
                shouldShowNoResultView = true
                foundSong = nil
                
            case .result(let song):
                withAnimation {
                    foundSong = song
                }
                shouldShowRecordButton = false
                shouldShowInfoText = false
                shouldShowAnimationView = false
            }
        }.store(in: &cancellables)
    }
    
	
	
	private func onRecordButtonTapped() {
		shazamViewModel.startListening()
	}
	
	private func goToPermissionSettings() {
		if let bundleID = Bundle.main.bundleIdentifier,
			let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleID)") {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	
	
	
}

struct ShazamView_Previews: PreviewProvider {
	 static var previews: some View {
		 ShazamView()
	 }
}

extension Color {
    static let slneonPurple = Color("soundLogPurple")
    static let slRealBlue = Color("soundLogRealBlue")
}
