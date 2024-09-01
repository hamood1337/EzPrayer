import SwiftUI

struct PrayerTimesView: View {
    @StateObject private var viewModel = PrayerTimesViewModel()
    @State private var showingSettings = false
    
    private let mainPrayers: [PrayTimes.TimeNames] = [.fajr, .dhuhr, .asr, .maghrib, .isha]
    
    var filteredPrayerTimes: [PrayerTime] {
        viewModel.prayerTimes.filter { mainPrayers.contains($0.name) }
            .sorted { mainPrayers.firstIndex(of: $0.name)! < mainPrayers.firstIndex(of: $1.name)! }
    }
    
    var body: some View {
        NavigationView {
            List {
//                Section(header: Text("Next Prayer")) {
//                    if let nextPrayer = viewModel.nextPrayer, mainPrayers.contains(nextPrayer.name) {
//                        HStack {
//                            Text(nextPrayer.name.rawValue.capitalized)
//                                .font(.headline)
//                            Spacer()
//                            Text(nextPrayer.formattedTime)
//                                .font(.title)
//                                .foregroundColor(.blue)
//                        }
//                    } else {
//                        Text("Calculating...")
//                    }
//                }
//                
//                Section(header: Text("Prayer Times")) {
                    ForEach(filteredPrayerTimes) { prayer in
                        HStack {
                            Text(prayer.name.rawValue.capitalized)
                            Spacer()
                            Text(prayer.formattedTime)
                                .foregroundColor(.secondary)
                        }
                    }
                }
//            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Prayer Times")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
}

struct PrayerTimesView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimesView()
    }
}
