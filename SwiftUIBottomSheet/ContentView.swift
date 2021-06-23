//
//  ContentView.swift
//  SwiftUIBottomSheet
//
//  Created by Mille Yin on 2021/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showDetail = false
    @State private var selectedItem: Restaurant?
    
    var body: some View {
        ZStack {//彈出view要處於上方，所以要加個zstack
            NavigationView {
                List(restaurants) { (restaurant) in
                    HStack {
                        Image(restaurant.image)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                        Text(restaurant.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    //解決list空白處無法點擊問題
                    .onTapGesture {
                        self.showDetail = true
                        self.selectedItem = restaurant
                    }
                }
                .navigationBarTitle("Restaurant List")
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
                    DetailView(isShow: $showDetail, restaurant: $0)
                        //調用被點擊的row
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))
                    //從底部上來
                })
                //如果不使用.map方式
//                if selectedRestaurant != nil {
//                    RestaurantDetailView(isShow: $showDetail, restaurant: selectedRestaurant!)
//                        .transition(.move(edge: .bottom))
//                        .animation(.easeInOut)
//                }//這種寫法和上面.map的寫法，等效
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BasicImageRow: View {
    var restaurant: Restaurant
    
    var body: some View {
        HStack {
            Image(restaurant.image)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(5)
            Text(restaurant.name)
        }
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
