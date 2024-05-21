//
//  CalendarTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 20.05.2024.
//

import UIKit
import UserNotifications
import CoreData

@available(iOS 16.0, *)
class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: UICalendarView!
    
    var markDates: [Date] = [] {
        didSet {
            updateDecorations()
            for date in markDates {
                scheduleNotification(for: date)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        calendarView.delegate = self
    }
    
    func scheduleNotification(for date: Date) {
           let content = UNMutableNotificationContent()
           content.title = "Upcoming Episode"
           content.body = "A new episode of a TV series in your favorites is airing tomorrow!"
           content.sound = .default
           
           let triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
           let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
           let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
           
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
           
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Failed to schedule notification: \(error)")
               }
           }
       }
    
    func prepareUI() {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendarView.calendar = gregorianCalendar
        
        calendarView.backgroundColor = .white
        calendarView.layer.cornerCurve = .continuous
        calendarView.layer.cornerRadius = 10.0
        calendarView.tintColor = UIColor.orange
        
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
