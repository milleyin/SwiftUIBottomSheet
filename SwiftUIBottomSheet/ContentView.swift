//
//  ContentView.swift
//  SwiftUIBottomSheet
//
//  Created by Mille Yin on 2021/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showDetail = false
    @State private var selectedItem: Book?
    
    var body: some View {
        ZStack {//彈出view要處於上方，所以要加個zstack
            NavigationView {
                List(books) { (book) in
                    HStack {
                        Image(book.image)
                            .resizable()
                            .frame(width: 60, height: 80)
                            //.cornerRadius(10)
                        VStack(alignment: .leading, spacing: 6.0) {
                            Text(book.name)
                                .bold()
                            Text(book.author)
                                .font(.system(.subheadline))
                                .foregroundColor(.secondary)
                            Text("¥ \(book.price)")
                                .background(
                                    Rectangle()
                                        .foregroundColor(.orange)
                                        .frame(width: 80)
                                )
                                .frame(width: 100, alignment: .leading)
                                .padding(.leading, 8)
                                .cornerRadius(2)
                                .foregroundColor(.white)
                            
                        }.padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    .contentShape(Rectangle())
                    //解決list空白處無法點擊問題
                    .onTapGesture {
                        self.showDetail = true
                        self.selectedItem = book
                    }
                }
                .navigationBarTitle("Library")
                .offset(y: showDetail ? -100 : 0)
                .animation(.easeOut(duration: 0.2))
            }
            if showDetail {
                //判斷是否被點擊
                BlankView(bgColor: .black)
                    .opacity(0.5)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                    .onTapGesture {
                        self.showDetail = false
                    }
                //設置當空視圖被點擊時，關閉RestaurantDetailView(設置showDetail為false)
                selectedItem.map({
                    DetailView(isShow: $showDetail, book: $0)
                        //調用被點擊的row
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))
                    //從底部上來
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct BlankView: View {  //建立一個空視圖，用作彈出層時的背景
    var bgColor: Color
    
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(bgColor)
        .edgesIgnoringSafeArea(.all)
    }
}
