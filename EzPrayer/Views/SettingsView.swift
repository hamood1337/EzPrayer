//
//  SettingsView.swift
//  EzPrayer
//
//  Created by Ahmad Maharmeh on 02/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: PrayerTimesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calculation Method")) {
                    Picker("Method", selection: $viewModel.calculationMethod) {
                        ForEach(PrayTimes.CalculationMethods.allCases, id: \.self) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("Location")) {
                    HStack {
                        Text("Latitude")
                        Spacer()
                        TextField("Latitude", value: $viewModel.latitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Longitude")
                        Spacer()
                        TextField("Longitude", value: $viewModel.longitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Time Zone")) {
                    HStack {
                        Text("GMT Offset")
                        Spacer()
                        TextField("GMT Offset", value: $viewModel.timeZone, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Adjustments")) {
                    Stepper(value: $viewModel.dhuhrMinutes, in: -30...30) {
                        HStack {
                            Text("Dhuhr Adjustment")
                            Spacer()
                            Text("\(viewModel.dhuhrMinutes) min")
                        }
                    }
                    
                    Picker("Asr Calculation", selection: $viewModel.asrCalculation) {
                        Text("Standard (Shafi, Maliki, Hanbali)").tag(0)
                        Text("Hanafi").tag(1)
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("High Latitude Adjustment")) {
                    Picker("Method", selection: $viewModel.highLatitudeRule) {
                        Text("No adjustment").tag(0)
                        Text("Midnight").tag(1)
                        Text("One-Seventh").tag(2)
                        Text("Angle-Based").tag(3)
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: PrayerTimesViewModel())
    }
}
