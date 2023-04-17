//
//  ContentView.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import SwiftUI
import CoreData

struct ContentView: View {
    init() {
        let window = NSApplication.shared.windows.first
        window?.setContentSize(NSSize(width: 300, height: 300))
    }
    
    var body: some View {
        VStack {
            Text("Hello Zapp!")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
