//
//  PrayerTimeModel.swift
//  EzPrayer
//
//  Created by Ahmad Maharmeh on 02/09/2024.
//

import Foundation

struct PrayerTime: Identifiable {
    let id = UUID()
    let name: PrayTimes.TimeNames
    let time: Date
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
