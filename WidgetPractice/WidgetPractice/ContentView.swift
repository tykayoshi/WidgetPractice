//
//  ContentView.swift
//  WidgetPractice
//
//  Created by Ilkay Hamit on 06/10/2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    var body: some View {
        Button("Reset Timeline") {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
