//
//  PrayerTimesViewModel.swift
//  EzPrayer
//
//  Created by Ahmad Maharmeh on 02/09/2024.
//

import Foundation
import Combine

class PrayerTimesViewModel: ObservableObject {
    @Published var prayerTimes: [PrayerTime] = []
    @Published var nextPrayer: PrayerTime?
    @Published var currentDate = Date()
    @Published var calculationMethod: PrayTimes.CalculationMethods = .mwl
    @Published var latitude: Double = 24.0
    @Published var longitude: Double = 54.0
    @Published var timeZone: Double = 4.0
    @Published var dhuhrMinutes: Int = 0 {
        didSet {
            prayTimes.dhuhrMinutes = dhuhrMinutes
            updatePrayerTimes()
        }
    }
    @Published var asrCalculation: Int = 0 {
        didSet {
            prayTimes.asrJuristic = asrCalculation
            updatePrayerTimes()
        }
    }
    @Published var highLatitudeRule: Int = 0 {
        didSet {
            prayTimes.adjustHighLats = highLatitudeRule
            updatePrayerTimes()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let prayTimes = PrayTimes()
    
    init() {
        setupTimers()
        updatePrayerTimes()
        
        $calculationMethod
            .combineLatest($latitude, $longitude, $timeZone)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updatePrayerTimes()
            }
            .store(in: &cancellables)
    }
    
    private func setupTimers() {
        Timer.publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.currentDate = Date()
                self?.updateNextPrayer()
            }
            .store(in: &cancellables)
    }
    
    func updatePrayerTimes() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        prayTimes.setMethod(calculationMethod)
        let times = prayTimes.getDatePrayerTimes(
            components.year!, components.month!, components.day!,
            latitude, longitude, timeZone
        )
        
        prayerTimes = times.map { (name, timeString) in
            let timeComponents = timeString.split(separator: ":")
            let hour = Int(timeComponents[0])!
            let minute = Int(timeComponents[1].prefix(2))!
            let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate)!
            return PrayerTime(name: name, time: date)
        }.sorted { $0.time < $1.time }
        
        updateNextPrayer()
    }
    
    private func updateNextPrayer() {
        nextPrayer = prayerTimes.first { $0.time > currentDate }
    }
}
