//
//  Date.swift
//  Picker
//
//  Created by Ilya on 17/03/2017.
//  Copyright © 2017 Ilya. All rights reserved.
//
//  Based on https://github.com/jonhocking/PrettyTimestamp/blob/master/NSDate%2BPrettyTimestamp.h

import Foundation

extension Date {
    /**
     Helper method for timestamps between now and the date provided
     @return lowercase string, see readme for examples
     */
    static func prettyTimestamp(since date: Date) -> String {
        return Date().prettyTimestamp(since: date)
    }

    /**
     Timestamp between now and the NSDate instance
     @return lowercase string, see readme for examples
     */
    func prettyTimestampSinceNow() -> String {
        return prettyTimestamp(since: Date())
    }

    /**
     Timestamp between the date provided and the NSDate instance
     @return lowercase string, see readme for examples
     */
    func prettyTimestamp(since date: Date) -> String {
        return prettyTimestamp(since: date, withFormat: nil)
    }

    /**
     Timestamp between the date provided and the receiver, using the given format
     @param date The date to compare to the receiver
     @param format The format to print in. Format options are: %i for interval, e.g. "4"; %u for unit, e.g. "weeks"; %c for constant, e.g. "ago".
     Any other characters in the format will be left untouched, i.e. they will appear in the output.
     If the format is nil, then the default format is used, i.e. "%i %u %c", e.g. "4 weeks ago"
     @note Use this method if you don't want the default format, for example, if you don't want spaces between the components, or if you want to add other decorative text.
     @return lowercase string in the given format, see readme for examples
     */
    func prettyTimestamp(since date: Date, withFormat customFormat: String?) -> String {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.minute, .hour, .day, .weekOfYear, .month, .year])
        let earliest = date < self ? date : self
        let latest: Date = (earliest == self) ? date : self
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        let format = (customFormat == nil || customFormat == "") ? "%i %u %c" : customFormat!
        if let year = components.year, year >= 1 {
            return NSLocalizedString("over a year ago", comment: "")
        }
        if let month = components.month, month >= 1 {
            return string(forComponentValue: month, withName: NSLocalizedString("month", comment: ""), andPlural: NSLocalizedString("months", comment: ""), format: format)
        }
        if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
            return string(forComponentValue: weekOfYear, withName: NSLocalizedString("week", comment: ""), andPlural: NSLocalizedString("weeks", comment: ""), format: format)
        }
        if let day = components.day, day >= 1 {
            return string(forComponentValue: day, withName: NSLocalizedString("day", comment: ""), andPlural: NSLocalizedString("days", comment: ""), format: format)
        }
        if let hour = components.hour, hour >= 1 {
            return string(forComponentValue: hour, withName: NSLocalizedString("hour", comment: ""), andPlural: NSLocalizedString("hours", comment: ""), format: format)
        }
        if let minute = components.minute, minute >= 1 {
            return string(forComponentValue: minute, withName: NSLocalizedString("minute", comment: ""), andPlural: NSLocalizedString("minutes", comment: ""), format: format)
        }
        return NSLocalizedString("just now", comment: "")
    }

    func string(forComponentValue componentValue: Int, withName name: String, andPlural plural: String, format: String) -> String {
        let timespan = NSLocalizedString(componentValue == 1 ? name : plural, comment: "")
        var output: String = format
        output = output.replacingOccurrences(of: "%i", with: String(componentValue))
        output = output.replacingOccurrences(of: "%u", with: timespan)
        output = output.replacingOccurrences(of: "%c", with: NSLocalizedString("ago", comment: ""))
        return output
    }
}
