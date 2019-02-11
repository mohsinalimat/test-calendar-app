//
//  ViewController.swift
//  Spreadsheet
//
//  Created by Oraz Atakishiyev on 2/10/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import UIKit
import SpreadsheetView
import MaterialComponents.MaterialBottomAppBar

class SpreadsheetVC: UIViewController {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    let bottomBarView = MDCBottomAppBarView()
    let arrWeekDates = Date().getWeekDates()
    let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    var hours = [String]()
    let data = [
        ["", "", "", "", "", "Take medicine", "", "", "", "", "", "", "", "", "", "", "Movie with family", "", "", "", "", "", ""],
        ["", "", "", "Leave for cabin", "", "", "", "", "Lunch with Tim", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "Downtown parade", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Fireworks show", "", "", ""],
        ["", "", "", "", "", "", "", "", "Family BBQ", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "Return home", "", "", "", "", "", ""],
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInitBottomAppBarTypicalUseSwiftExample()
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        spreadsheetView.bounces = false
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        
        //spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .solid(width: 1, color: Color.scheduleGrid)
        
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        for i in 1 ... 23 {
            hours.append(String(format: "%02d:00", i))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    func commonInitBottomAppBarTypicalUseSwiftExample() {
        titleLab.text = getMonthYear()
        
        bottomBarView.autoresizingMask = [ .flexibleWidth, .flexibleTopMargin ]
        view.addSubview(bottomBarView)
        
        // Add touch handler to the floating button.
        bottomBarView.floatingButton.addTarget(self,
                                               action: #selector(didTapFloatingButton),
                                               for: .touchUpInside)
        
        // Set the image on the floating button.
        let addImage = UIImage(named:"ic_add")?.withRenderingMode(.alwaysTemplate)
        bottomBarView.floatingButton.setImage(addImage, for: .normal)
        bottomBarView.floatingButton.tintColor = .white
        bottomBarView.floatingButton.backgroundColor = Color.green
        
        // Set the position of the floating button.
        bottomBarView.floatingButtonPosition = .center
        
        // Configure the navigation buttons to be shown on the bottom app bar.
        let barButtonLeadingItem = UIBarButtonItem()
        let menuImage = UIImage(named:"ic_calendar")?.withRenderingMode(.alwaysTemplate)
        barButtonLeadingItem.image = menuImage
        barButtonLeadingItem.tintColor = Color.gray
        
        let barButtonTrailingItem = UIBarButtonItem()
        let searchImage = UIImage(named:"ic_subtract")?.withRenderingMode(.alwaysTemplate)
        barButtonTrailingItem.image = searchImage
        barButtonTrailingItem.tintColor = Color.green
        
        bottomBarView.leadingBarButtonItems = [ barButtonLeadingItem ]
        bottomBarView.trailingBarButtonItems = [ barButtonTrailingItem ]
    }
    
    func layoutBottomAppBar() {
        let size = bottomBarView.sizeThatFits(view.bounds.size)
        let bottomBarViewFrame = CGRect(x: 0,
                                        y: view.bounds.size.height - size.height,
                                        width: size.width,
                                        height: size.height)
        bottomBarView.frame = bottomBarViewFrame
    }
    
    @objc func didTapFloatingButton() {
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutBottomAppBar()
    }
    
    #if swift(>=3.2)
    @available(iOS 11, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        layoutBottomAppBar()
    }
    #endif

}

extension SpreadsheetVC: SpreadsheetViewDataSource, SpreadsheetViewDelegate {
    // MARK: DataSource
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 1 + hours.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        
        return (self.view.frame.width/8)-1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 32
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        
        if case (1...(days.count + 1), 0) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = Color.green
            cell.gridlines.top = .none
            cell.gridlines.left = .none
            cell.gridlines.bottom = .none
            cell.gridlines.right = .none
            return cell
        } else if case (1...(days.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            let day = arrWeekDates.thisWeek[indexPath.column - 1].toDate(format: "dd")
            if (Int(day) == getTodayInt())
            {
                cell.label.layer.masksToBounds = true
                cell.label.layer.cornerRadius = 12.5
                cell.label.backgroundColor = Color.green
                cell.label.textColor = .white
            }
            cell.label.text = day
            cell.gridlines.left = .none
            cell.gridlines.right = .none
            return cell
        } else if case (0, 0...1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.gridlines.left = .none
            cell.gridlines.right = .none
            cell.gridlines.top = .none
            return cell
        } else if case (0, 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = hours[indexPath.row - 2]
            cell.gridlines.top = .none
            cell.gridlines.left = .none
            cell.gridlines.bottom = .none
            cell.gridlines.right = .none
            return cell
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = data[indexPath.column - 1][indexPath.row - 2]
            if !text.isEmpty {
                let color = UIColor(rgb: 0x9B51E0)
                cell.color = color
            } else {
                cell.color = .white
            }
            
            let day = arrWeekDates.thisWeek[indexPath.column - 1].toDate(format: "dd")
            if (Int(day)! < getTodayInt())
            {
                cell.color = UIColor(rgb: 0xF2F9F2)
            }
            return cell
        }
        return nil
    }
    
    /// Delegate
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
    }
    
    func getMonthYear() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "MMMM"
        let stringDate = dateFormatter.string(from: Date())
        
        return "\(stringDate.capitalizingFirstLetter()) \(year) г., Неделя 2"
    }
    
    func getTodayInt() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return day
    }

}


