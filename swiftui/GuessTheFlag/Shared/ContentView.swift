//
//  ContentView.swift
//  Shared
//
//  Created by Jurvis on 1/16/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Delete selection", action: executeDelete)
    }
    
    func executeDelete() {
        print("Now deleting...")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
