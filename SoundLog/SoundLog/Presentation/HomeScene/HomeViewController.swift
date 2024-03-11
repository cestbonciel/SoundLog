//
//  HomeViewController.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/08/21.
//

import UIKit

import FSCalendar
import SnapKit
import RealmSwift

class HomeViewController: UIViewController {
    
    let dummyData = ["바닷소리", "음악소리"]
	struct Icon {
	  static let leftIcon = UIImage(systemName: "chevron.left")?
		 .withTintColor(.label, renderingMode: .alwaysOriginal)
	  static let rightIcon = UIImage(systemName: "chevron.right")?
		 .withTintColor(.label, renderingMode: .alwaysOriginal)
	}
	
	@IBOutlet weak var topSideStackView: UIStackView!
	@IBOutlet weak var monthlyArchive: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		setCalendarView()
        
		setupHomeUI()
        tableView.dataSource = self
        tableView.delegate = self
		configureCalendar()
        
        
	}
	
    var soundLogs: Results<StorageSoundLog>! {
        didSet {
            tableView.reloadData()
        }
    }
    
//	var selectedDate: DateComponents? = nil
	
	@IBOutlet weak var AddButton: UIButton!
	
	let headerDateFormatter: DateFormatter = {
		let date = DateFormatter()
		date.dateFormat = "YYYY년 MM월 W주차"
		date.locale = Locale(identifier: "ko_kr")
		date.timeZone = TimeZone(identifier: "KST")
		return date
	}()
	
	
	
	private lazy var headerLabel: UILabel = {
		let headerDate = UILabel()
		headerDate.font = .gmsans(ofSize: 16.0, weight: .GMSansBold)
		headerDate.textColor = UIColor.black
		headerDate.text = headerDateFormatter.string(from: Date())
		headerDate.translatesAutoresizingMaskIntoConstraints = false
		return headerDate
	}()
	/*
     let button = UIButton(type: .custom)
     
     button.layer.borderWidth = 1
     button.layer.cornerRadius = 13
     button.layer.borderColor = NagazaAsset.Colors.gray5.color.cgColor
     
     var config = UIButton.Configuration.plain()
     config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
     config.attributedTitle = AttributedString("내 정보 보기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.ngaP2Sb,
          NSAttributedString.Key.foregroundColor: NagazaAsset.Colors.gray5.color
         ])
     )
     button.configuration = config
     */
	lazy var togglePeriodButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        config.attributedTitle = AttributedString("주", attributes:  titleContainer)
        
        config.image = UIImage(systemName: "arrowtriangle.down.fill")
        config.imagePadding = 2
        config.titlePadding = 2
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let button = UIButton()
        
        config.imagePlacement = NSDirectionalRectEdge.trailing
        button.configuration = config
        button.tintColor = .white
        button.layer.cornerRadius = 4
        
		button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        
		return button
	}()
    // MARK: - Calendar View ---
    private func configureCalendar() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.select(Date())
        
        calendarView.locale = Locale(identifier: "ko_kr")
        calendarView.scope = .week
        calendarView.appearance.headerDateFormat = "YYYY년 MM월 W주차"
        
        calendarView.headerHeight = 0
        calendarView.weekdayHeight = 32
        
        calendarView.appearance.weekdayFont = .gmsans(ofSize: 16, weight: .GMSansMedium)
        calendarView.appearance.headerTitleFont = .gmsans(ofSize: 16, weight: .GMSansMedium)
        calendarView.appearance.titleFont = .gmsans(ofSize: 14, weight: .GMSansMedium)
        calendarView.appearance.subtitleFont = .gmsans(ofSize: 14, weight: .GMSansLight)
        
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.weekdayTextColor = UIColor.systemDimGray
        calendarView.appearance.titleDefaultColor = UIColor.black
        
        calendarView.appearance.titleWeekendColor = .vividRedPurple
        
        calendarView.appearance.titlePlaceholderColor = UIColor.systemGray2
        calendarView.appearance.todayColor = UIColor.neonYellow
        calendarView.appearance.selectionColor = UIColor.neonPurple
        calendarView.appearance.titleTodayColor = UIColor.black
        
    }
    
    func getNextWeek(date: Date) -> Date {
      return  Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: date)!
    }
    
    func getPreviousWeek(date: Date) -> Date {
      return  Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: date)!
    }
    //MARK: - method for calendar ---
    @objc func tapNextWeek() {
      self.calendarView.setCurrentPage(getNextWeek(date: calendarView.currentPage), animated: true)
    }
    
    @objc func tapBeforeWeek() {
      self.calendarView.setCurrentPage(getPreviousWeek(date: calendarView.currentPage), animated: true)
    }
	
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SoundLogTableCell.self, forCellReuseIdentifier: SoundLogTableCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
	@objc func tapToggleButton() {
		if self.calendarView.scope == .month {
			self.calendarView.setScope(.week, animated: true)
			
			self.headerDateFormatter.dateFormat = "YYYY년 MM월 W주차"
			self.togglePeriodButton.setTitle("주", for: .normal)
			self.togglePeriodButton.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
			self.headerLabel.text = headerDateFormatter.string(from: calendarView.currentPage)
		} else {
			self.calendarView.setScope(.month, animated: true)
			self.headerDateFormatter.dateFormat = "YYYY년 MM월"
			self.togglePeriodButton.setTitle("월", for: .normal)
			self.togglePeriodButton.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
			self.headerLabel.text = headerDateFormatter.string(from: calendarView.currentPage)
		}
	}
	
	
	lazy var calendarView = FSCalendar(frame: .zero)

	@IBAction func leaveLogButtonTapped(_ sender: Any) {
		let viewController = SoundLogViewController()
		viewController.isModalInPresentation = true
		viewController.modalPresentationStyle = .fullScreen
		self.present(viewController, animated: true)
	}
	

	private func setupHomeUI() {
		view.addSubview(topSideStackView)
		view.addSubview(calendarView)
		view.addSubview(headerLabel)
		view.addSubview(togglePeriodButton)
		headerLabel.snp.makeConstraints {
			$0.top.equalTo(topSideStackView.snp.bottom).offset(24)
			$0.left.equalToSuperview().inset(30)
		}
		
		togglePeriodButton.snp.makeConstraints {
			$0.centerY.equalTo(headerLabel.snp.centerY)
			
			$0.trailing.equalTo(topSideStackView.snp.trailing)
		}
		
		calendarView.snp.makeConstraints {
			$0.top.equalTo(topSideStackView.snp.bottom).offset(64)
			$0.left.equalToSuperview().inset(16)
			$0.right.equalToSuperview().inset(16)
			$0.height.equalTo(240)
		}
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

	}

	
}

//MARK: - Preview Setting
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> some UIViewController {
		return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		
	}
}

struct HomeViewController_Preview: PreviewProvider {
	static var previews: some View {
		HomeViewControllerRepresentable()
	}
}
#endif

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		
		calendarView.snp.updateConstraints {
			$0.height.equalTo(bounds.height)
		}
		self.view.layoutIfNeeded()
	}
	
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		let currentPage = calendarView.currentPage
		headerLabel.text = headerDateFormatter.string(from: currentPage)
	}
}

// MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dummyData.count
        return SoundInfo.list.count
//        let test = soundManager.sounds.count
//        print(test)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let soundInfo = SoundInfo.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SoundLogTableCell.identifier, for: indexPath) as! SoundLogTableCell
        cell.configure(soundInfo)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
}
