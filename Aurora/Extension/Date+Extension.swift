//
//  Date+Extension.swift
//  Aurora
//
//  Created by kwamecorp on 17/03/2020.
//  Copyright © 2020 GreenSphereStudios. All rights reserved.
//

import Foundation

extension Date {

  var millisecondsSince1970: Double {
    return Double((self.timeIntervalSince1970 * 1000.0).rounded())
  }

  func changeDays(by days: Int) -> Date {
     return Calendar.current.date(byAdding: .day, value: days, to: self)!
  }

  init(milliseconds: Double) {
      self = Date(timeIntervalSince1970: milliseconds / 1000)
  }

  var isToday: Bool {
    return Calendar.autoupdatingCurrent.isDateInToday(self)
  }

  var startOfDay: Date {
    return Calendar.autoupdatingCurrent.startOfDay(for: self)
  }

  func simpleDate(_ format: String = "h:mm a") -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = format
    return formatter.string(from: self)
  }

  func timeSincePast(from date: Date = Date(), minutes: Double) -> Bool {
    return abs(timeIntervalSince(date)) > minutes * 60
  }

  func hoursLeftSince() -> Int {
    let interval = Date().timeIntervalSince(self)
    let hour = interval / 3600
    return Int(hour)
  }

  func daysLeftCount() -> Int {
    let days = Calendar.autoupdatingCurrent.dateComponents([.day], from: Date().startOfDay, to: self.startOfDay).day
    guard let daysLeft = days else {
      return -1
    }
    return daysLeft
  }

  func getCompactDate() -> String {
    let format = DateFormatter()
    format.dateFormat = "yyyy_MM_dd_hh_mm_ss_a"
    let formattedDate = format.string(from: self)
    return formattedDate
  }

  static func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: start, to: end).day!
  }
}
