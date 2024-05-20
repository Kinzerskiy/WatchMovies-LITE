//
//  CalendarTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 20.05.2024.
//

import UIKit

@available(iOS 16.0, *)
class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: UICalendarView!
    
    var markDates: [Date] = [] {
        didSet {
            calendarView.setNeedsDisplay()
            print(markDates)
        }
    }
    
    var tvSeriesDetails: [TVSeriesDetails] = [] {
        didSet {
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        calendarView.delegate = self
    }
    
    func prepareUI() {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        
        calendarView.backgroundColor = .secondarySystemBackground
        calendarView.layer.cornerCurve = .continuous
        calendarView.layer.cornerRadius = 10.0
        calendarView.tintColor = UIColor.systemTeal
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        calendarView.availableDateRange = DateInterval.init(start: Date.now, end: Date.distantFuture)
    }
}

@available(iOS 16.0, *)
extension CalendarTableViewCell:  UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let date = calendarView.calendar.date(from: dateComponents)!
        
        for markedDate in markDates {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: markedDate)
            
            let calendarDateFormatter = DateFormatter()
            calendarDateFormatter.dateFormat = "dd-MM-yyyy"
            if let calendarDate = calendarDateFormatter.date(from: dateString),
               Calendar.current.isDate(calendarDate, inSameDayAs: date) {
                let font = UIFont.systemFont(ofSize: 10)
                let configuration = UIImage.SymbolConfiguration(font: font)
                let image = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
                
                return .image(image)
            }
        }
        return nil
    } 
}

@available(iOS 16.0, *)
extension CalendarTableViewCell: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print("Selected Date:", dateComponents)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}
