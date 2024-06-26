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
	struct Icon {
	  static let leftIcon = UIImage(systemName: "chevron.left")?
		 .withTintColor(.label, renderingMode: .alwaysOriginal)
	  static let rightIcon = UIImage(systemName: "chevron.right")?
		 .withTintColor(.label, renderingMode: .alwaysOriginal)
	}
	
	@IBOutlet weak var topSideStackView: UIStackView!
	@IBOutlet weak var monthlyArchive: UILabel!
    
    var soundLogs: Results<StorageSoundLog>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        let defaultDate = calendarView.selectedDate ?? calendarView.today!
        soundLogs = StorageSoundLog.fetchDate(date: defaultDate)
        calendarView.reloadData()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()

		setupHomeUI()
        tableView.dataSource = self
        tableView.delegate = self
        
        soundLogs = StorageSoundLog.fetchDate(date: Date())
        
		configureCalendar()
        
	}
	
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
    
    lazy var togglePeriodButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .gmsans(ofSize: 10, weight: .GMSansMedium)
        config.attributedTitle = AttributedString("주", attributes:  titleContainer)
        
        config.image = UIImage(systemName: "arrowtriangle.down.fill")
        config.imagePadding = 2
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let button = UIButton()
        
        config.imagePlacement = NSDirectionalRectEdge.trailing
        button.configuration = config
        button.tintColor = .white
        button.layer.cornerRadius = 4
        
		button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
		return button
        
	}()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView: UIView = {
        let view = UIView()
        
        return view
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
        calendarView.appearance.subtitleFont = .gmsans(ofSize: 8, weight: .GMSansLight)
        
        calendarView.appearance.headerTitleColor = UIColor.black
        calendarView.appearance.weekdayTextColor = UIColor.systemDimGray
        calendarView.appearance.titleDefaultColor = UIColor.black
        
        calendarView.appearance.titleWeekendColor = .vividRedPurple
        
        calendarView.appearance.titlePlaceholderColor = UIColor.systemGray2
        calendarView.appearance.todayColor = UIColor.neonYellow
        calendarView.appearance.selectionColor = UIColor.neonPurple
        calendarView.appearance.eventDefaultColor = .vividBlueGreen
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
	
    // MARK: - TableView: SoundLogs
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
			
            
            updateToggleButtonTitle(to: "주")
			self.togglePeriodButton.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
			self.headerLabel.text = headerDateFormatter.string(from: calendarView.currentPage)
		} else {
			self.calendarView.setScope(.month, animated: true)
			self.headerDateFormatter.dateFormat = "YYYY년 MM월"
			
            
            updateToggleButtonTitle(to: "월")
            
			self.togglePeriodButton.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
			self.headerLabel.text = headerDateFormatter.string(from: calendarView.currentPage)
		}
	}
	
    func updateToggleButtonTitle(to newTitle: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = .gmsans(ofSize: 12, weight: .GMSansMedium)
        togglePeriodButton.configuration?.attributedTitle = AttributedString(newTitle, attributes: titleContainer)
    }
    
	lazy var calendarView = FSCalendar(frame: .zero)
    // MARK: - SoundLogViewController
    
    @IBAction func addLogButtonTapped(_ sender: UIButton) {
        let vc = SoundLogViewController()
        vc.viewModel.createdAt.value = calendarView.selectedDate ?? Date()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
	}
	
   

    private func setupHomeUI() {
        view.addSubview(topSideStackView)
        view.addSubview(calendarView)
        view.addSubview(headerLabel)
        view.addSubview(togglePeriodButton)
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(topSideStackView.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(16)
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        switch dateFormatter.string(from: date) {
        case dateFormatter.string(from: Date()):
            return "오늘"
        default:
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        if Calendar.current.isDateInToday(date) {
            return UIColor.black // "오늘" 부제목을 검은색으로 설정
        }
        return nil
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        headerLabel.text = headerDateFormatter.string(from: date)
        soundLogs = StorageSoundLog.fetchDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return StorageSoundLog.fetchDate(date: date).count
    }
}

// MARK: - TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var categoryIcon = CategoryIconType.Type.self
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SoundLogTableCell.identifier, for: indexPath) as? SoundLogTableCell else { fatalError("Unable to dequeue SoundLogTableCell") }
        let soundLog = soundLogs[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(with: soundLog)
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}


extension HomeViewController: SoundLogTableCellDelegate {
    func didTapEditButton(for cell: SoundLogTableCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let soundLog = soundLogs?[indexPath.row] else { return }
        // Initializer for conditional binding must have Optional type, not 'StorageSoundLog'
        
        
        let detailVC = SoundLogDetailViewController()
        detailVC.editSoundLogData = soundLog
        
        detailVC.editViewModel = SoundLogViewModel(log: soundLog)
        
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
    
    func didToggleBookmark(for cell: SoundLogTableCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let soundLog = soundLogs[indexPath.row]
        
        if BookmarkSoundLog.isBookmarked(for: soundLog) {
            BookmarkSoundLog.removeBookmark(for: soundLog)
        } else {
            BookmarkSoundLog.addBookmark(for: soundLog)
        }

        cell.updateBookmarkIcon(isBookmarked: BookmarkSoundLog.isBookmarked(for: soundLog))
    }
}


extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }

}

/*
 view.addSubview(topSideStackView)
 
 topSideStackView.layer.borderColor = UIColor.systemGreen.cgColor
 topSideStackView.layer.borderWidth = 1
 
 self.view.addSubview(scrollView)
 
 //scrollView.addSubviews([headerLabel, togglePeriodButton, calendarView, tableView])
 
 self.scrollView.addSubview(contentView)
 contentView.addSubviews([headerLabel, togglePeriodButton, calendarView, tableView])
 
 headerLabel.layer.borderColor = UIColor.magenta.cgColor
 headerLabel.layer.borderWidth = 1
 
 togglePeriodButton.layer.borderColor = UIColor.magenta.cgColor
 togglePeriodButton.layer.borderWidth = 1
 
 scrollView.snp.makeConstraints {
     $0.top.equalTo(topSideStackView.snp.bottom).offset(16)
     $0.left.right.equalToSuperview().inset(16)
     //$0.bottom.equalTo(view.snp.bottom)
     $0.bottom.equalTo(view.safeAreaLayoutGuide)
 }
 
 scrollView.layer.borderColor = UIColor.systemPurple.cgColor
 scrollView.layer.borderWidth = 1
 
 
 contentView.layer.borderColor = UIColor.yellow.cgColor
 contentView.layer.borderWidth = 1
 
 contentView.snp.makeConstraints {
     $0.edges.equalTo(scrollView.contentLayoutGuide)
     $0.width.equalTo(scrollView.frameLayoutGuide)
     //$0.bottom.equalTo(scrollView.snp.bottom)
 }
 
 headerLabel.snp.makeConstraints {
     $0.centerY.equalTo(togglePeriodButton.snp.centerY)
     $0.left.equalTo(contentView.snp.left)
     //$0.left.equalTo(scrollView.snp.left)
 }
 
 togglePeriodButton.snp.makeConstraints {
     //$0.top.equalTo(scrollView)
     $0.top.equalTo(contentView)
     
     $0.trailing.equalTo(topSideStackView.snp.trailing)
 }

 calendarView.snp.makeConstraints {
     $0.top.equalTo(headerLabel.snp.bottom).offset(8)
     $0.left.right.equalTo(contentView)
     //$0.width.equalTo(contentView)
     
     $0.height.equalTo(240)
 }
 
 
 tableView.dataSource = self
 tableView.delegate = self
 
 //view.addSubview(tableView)
 
 tableView.snp.makeConstraints {
     $0.top.equalTo(calendarView.snp.bottom).offset(8)
     $0.width.equalTo(contentView)
     //$0.bottom.equalTo(view.safeAreaLayoutGuide)
     $0.bottom.equalTo(contentView.snp.bottom)
 }
 
 */
