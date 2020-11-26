//
//  SectionListView.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 25/11/2020.
//

import SwiftUI

struct SectionModel<T: Identifiable> {
    var isExpanded: Bool
    var title: String
    var data: [T]
}

struct SectionListView: View {
    var data = [["a", "b"], ["a", "b"], ["a", "b"], ["a", "b"], ["a", "b"]]
    @State var dataSource: [SectionModel<String>] = []
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach((0..<dataSource.count), id:\.self) { index in
                    HStack {
                        Text("Section \(index)")
                        Spacer()
                        Image(systemName: "arrowtriangle.right")
                            .rotationEffect(.degrees(dataSource[index].isExpanded ? 90 : 0))
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            dataSource[index].isExpanded.toggle()
                        }
                    }
                    if dataSource[index].isExpanded {
                        LazyVStack(alignment: .leading) {
                            ForEach(dataSource[index].data, id:\.self) { data in
                                Text("Row \(data)")
                            }
                        }
                    }
                }
            }
        }.frame(alignment: .leading)
        .padding()
        .onAppear(perform: {
            getDatasource()
        })
    }
    
    func getDatasource() {
        for sub in data {
            dataSource.append(SectionModel(isExpanded: true, title: "\(sub.count)", data: sub))
        }
    }
}

struct SectionListView_Previews: PreviewProvider {
    static var previews: some View {
        SectionListView()
    }
}
