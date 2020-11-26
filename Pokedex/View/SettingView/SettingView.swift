//
//  SettingView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 24/11/2020.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    
    @State var background = Color.clear
    @Binding var show: Bool

    var body: some View {
        ZStack {
            ZStack {
                Color.black.opacity(isDarkMode ? 1 : 0)
                Color.white.opacity(isDarkMode ? 0 : 1)
            }.animation(Animation.easeInOut(duration: 0.2))
            CustomBigTitleNavigationView(content: {
                SettingContentView()
            }, header: {
                BigTitle(text: "Settings")
            }, stickyHeader: {
                NamedHeaderView(name: "Settings")
            }, maxHeight: 150)

            VStack {
                HStack(alignment: .center) {
                    BackButtonView(isShowing: $show)
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 30)
            .padding(.leading, 20)
        }.ignoresSafeArea()
        .statusBar(hidden: true)
    }
}

struct SettingContentView: View {
    @AppStorage(Keys.isDarkMode.rawValue) var isDarkMode: Bool = false
    @State var isOn = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Theme Setting")
                .font(Biotif.medium(size: 12).font)
                .foregroundColor(isDarkMode ? .white : .gray)
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Theme")
                        .font(Biotif.bold(size: 20).font)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Text(isOn ? "Dark mode" : "Light mode")
                        .font(Biotif.light(size: 15).font)
                        .padding(.leading, 20)
                        .foregroundColor(isDarkMode ? .white : .black)
                }.padding()
                AnimatedSwitch(isOn: $isOn)
            }
        }.onChange(of: isOn, perform: { value in
            Settings.isDarkMode.wrappedValue = value
        }).onAppear {
            isOn = Settings.isDarkMode.wrappedValue
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(show: .constant(true))
    }
}
