//
//  ContentView.swift
//  Conversion
//
//  Created by Raymond Chen on 2/4/22.
//

import SwiftUI

struct ContentView: View {
    
    enum AvailableUnits: String, Comparable {
        case length
        case temp
        case time
        case volume
        
        static func < (lhs: Self, rhs: Self) -> Bool {
            return lhs.rawValue < rhs.rawValue
          }
    }
    
    @State private var unitSelection: AvailableUnits = .length
    @State private var convertUnit: Dimension = UnitLength.meters
    @State private var toUnit: Dimension = UnitLength.feet
    @State private var convertNumber: Double = 0.0
    
    private var toNumber: Measurement<Dimension> {
        let inputValue = Measurement(value: convertNumber, unit: convertUnit)
        let outputValue = inputValue.converted(to: toUnit)
        return outputValue
    }
    
    let units: [AvailableUnits : [Dimension]] = [
        .length : [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        .temp : [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        .volume : [UnitVolume.liters, UnitVolume.milliliters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons],
        .time : [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours, UnitDuration.days]
        
    ]
    
    let formatter: MeasurementFormatter
    
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .medium
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Convert Unit", selection: $unitSelection){
                        ForEach(units.keys.sorted(), id: \.self) { key in
                            Text(key.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Picker("Convert Unit", selection: $convertUnit){
                        ForEach(units[unitSelection]!, id: \.self) { unit in
                            Text(formatter.string(from: unit))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Picker("To Unit", selection: $toUnit){
                        ForEach(units[unitSelection]!, id: \.self) { unit in
                            Text(formatter.string(from: unit))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            .navigationTitle("Unit Conversion")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension UnitLength {
    var localizedName: String {
        if self == UnitLength.meters {
            return "Meter"
        } else if self == UnitLength.kilometers {
            return "Kilometer"
        } else if self == UnitLength.feet {
            return "Feet"
        } else if self == UnitLength.yards {
            return "Yards"
        } else if self == UnitLength.miles {
            return "Miles"
        } else {
            return "Unknown"
        }
    }
}

extension UnitDuration {
    static let SecondsPerDay: Double = 86_400
    
    static let days = UnitDuration("days", coefficient: SecondsPerDay)
    
    convenience init (_ symbol: String, coefficient: Double) {
            self.init(symbol: symbol, converter: UnitConverterLinear(coefficient: coefficient))
        }
}
