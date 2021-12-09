//
//  Log.swift
//  Aurora
//
//  Created by Pedro Saldanha on 09/12/2021.
//  Copyright © 2021 GreenSphereStudios. All rights reserved.
//

import Foundation
import CocoaLumberjack

class Log {

  let fileLogger: DDFileLogger
  static let bleLibContext = 1
  static let defaultContext = 0

  init() {
    let fileLogFormatter = LogFileFormatter()
    let logFormatter = LogOSFormatter(filterContextId: Log.defaultContext)

    let normalOsLog = DDOSLogger(subsystem: Bundle.main.bundleIdentifier, category: "Main")
    normalOsLog.logFormatter = logFormatter
    DDLog.add(normalOsLog) // Uses os_log

    fileLogger = DDFileLogger() // File Logger
    fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
    fileLogger.logFileManager.maximumNumberOfLogFiles = 3
    fileLogger.logFormatter = fileLogFormatter
    DDLog.add(fileLogger)
  }

  func debug(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let m = message()
    DDLogDebug(String(describing: m), context: context ,file: file, function: function, line: line)
  }

  func info(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let m = message()
    DDLogInfo(String(describing: m), context: context, file: file, function: function, line: line)
  }

  func error(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let m = message()
    DDLogError(String(describing: m), context: context, file: file, function: function, line: line)
  }

  func verbose(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let m = message()
    DDLogVerbose(String(describing: m), context: context, file: file, function: function, line: line)
  }

  func warning(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    let m = message()
     DDLogWarn(String(describing: m), context: context, file: file, function: function, line: line)
   }

  func notice(_ message: @autoclosure () -> Any, context: Int = 0, file: StaticString = #file, function: StaticString = #function, line: UInt = #line){
    let m = message()
    DDLogDebug(String(describing: m), context: context, file: file, function: function, line: line)
  }

    func getAllFiles() -> [Data] {

      let allFiles: [Data] =
        fileLogger.logFileManager.sortedLogFilePaths.map {
        let fileUrl = URL.init(fileURLWithPath: $0, isDirectory: false)
        if let logFileData = try? Data(contentsOf: fileUrl) {
          return logFileData
        }
          return Data.init()
        }.filter { !$0.isEmpty }

      return allFiles
    }

  private class BaseLogFormatter: DDDispatchQueueLogFormatter {

    func getEmoji(message: DDLogMessage) -> String {
      switch message.flag {
      case DDLogFlag.debug:
        return "☘️"
      case DDLogFlag.error:
        return "‼️"
      case DDLogFlag.warning:
        return "⚠️"
      case DDLogFlag.info:
        return "💠"
      case DDLogFlag.verbose:
        return "💬"
      default:
        return ""
      }
    }
  }

  private class LogFileFormatter: BaseLogFormatter {

    let dateFormatter: DateFormatter

    override init() {
      dateFormatter = DateFormatter()
      dateFormatter.formatterBehavior = .default
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
      super.init()
    }

    override func format(message: DDLogMessage) -> String? {

      let tag = message.context == Log.bleLibContext ? "[BLE ]" : "[MAIN]"
      let emoji = getEmoji(message: message)
      let messageToLog = "\(emoji) \(tag) [\(message.fileName):\(message.line) \(message.function!)] \(message.message) \(emoji)"

      let dateAndTime = dateFormatter.string(from: message.timestamp)
      return "\(dateAndTime) \(messageToLog)"
    }
  }

  private class LogOSFormatter: BaseLogFormatter {

    let filterContextId: Int

    init(filterContextId: Int) {
      self.filterContextId = filterContextId
      super.init()
    }

    override func format(message: DDLogMessage) -> String? {
      //Filter by context
      if filterContextId != -1 && message.context != filterContextId { return nil }

      let emoji = getEmoji(message: message)
      let messageToLog = "\(emoji) [\(message.fileName):\(message.line) \(message.function!)] \(message.message) \(emoji)"

      return messageToLog
    }
  }
}
