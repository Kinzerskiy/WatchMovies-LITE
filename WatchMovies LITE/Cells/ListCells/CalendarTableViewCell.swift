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
            updateDecorations()
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
    
    private func updateDecorations() {
        
        let uniqueMarkDates = Array(Set(markDates))
        
        
        calendarView.reloadDecorations(forDateComponents: [], animated: true)
        
        
        if !uniqueMarkDates.isEmpty {
            calendarView.reloadDecorations(forDateComponents: uniqueMarkDates.map {
                Calendar.current.dateComponents([.year, .month, .day], from: $0)
            }, animated: true)
        }
    }
    
    
    func clearMarkDates() {
        markDates.removeAll()
        updateDecorations()
    }
}

@available(iOS 16.0, *)
extension CalendarTableViewCell:  UICalendarViewDelegate {
    
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = Calendar.current.date(from: dateComponents) else {
            return nil
        }
        
        if markDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            let font = UIFont.systemFont(ofSize: 10)
            let configuration = UIImage.SymbolConfiguration(font: font)
            let image = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
            return .image(image)
        }
        return nil
    }
}

@available(iOS 16.0, *)
extension CalendarTableViewCell: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let selectedDate = Calendar.current.date(from: dateComponents) else { return }
        
        
        NotificationCenter.default.post(name: .dateSelected, object: selectedDate)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
    }
}
