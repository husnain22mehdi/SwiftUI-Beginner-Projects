//
//  ContentView.swift
//  WeSplit
//
//  Created by Husnain on 21/10/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var amount = 0.0
    @State private var numOfPeople = 2
    @State private var tipPct = 10
    @FocusState private var amountIsFocused : Bool
    
    private let tipOptions = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let totalBill = amount + (amount * (Double(tipPct) / 100.0))
        let total = totalBill / Double(numOfPeople + 2)
        return total
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of People: ", selection: $numOfPeople) {
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                Section{
                    Picker("Tip Percentage", selection:  $tipPct){
                        ForEach(tipOptions, id: \.self){
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.segmented)
                }header: {
                    Text("How much tip do you want to leave?")
                }
                Section{
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }.navigationTitle("WeSplit")
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            amountIsFocused = false
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
