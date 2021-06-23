//
//  RestaurantDetailView.swift
//  SwiftUIBottomSheet
//
//  Created by Mille Yin on 2021/6/22.
//

import SwiftUI

struct DetailView: View {
    
    @GestureState private var dragState = DragState.inactive
    //拖動手勢狀態
    @State private var positionOffset: CGFloat = 0.0
    //view偏移值
    
    @State private var viewState = ViewState.half
    //視圖狀態
    
    @Binding var isShow: Bool
    //與ContentView之間傳遞視圖狀態變量
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var book: Book
    var body: some View {
        
        GeometryReader{ geometry in
            //存取父view的大小與位置
            VStack {
                Spacer()
                HandleBar()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color(.systemGray5))
                TitleBar(isShow: $isShow)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                ScrollView(.vertical){
                    HeaderView(book: self.book)
                    DetailInfoView(icon: "map", info: self.book.author)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.top, 3)
                    DetailInfoView(icon: "phone", info: self.book.isbn)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.top, 3)
                    DetailInfoView(icon: nil, info: self.book.description)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.top, 3)
                }.edgesIgnoringSafeArea(.all)
                //.disabled(self.viewState == .half || self.dragState.isDragging)
                //禁用內容拖動功能，這裡設置為：視圖半開且被拖動時，禁用內容拖動
//                .animation(nil)
                //這裡加個nil，內容則不會動，也就是動畫的設置，不會應用到scrollview上

            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10, antialiased: true)
            .offset(y: geometry.size.height / 2 + self.dragState.translation.height + self.positionOffset)
            //.offset(y: 0)
            //初始位置(屏幕尺寸除2)加上拖拽位移
            .animation(.interpolatingSpring(stiffness: 200.0, damping: 20.0, initialVelocity: 10.0))
            //剛性(stiffness)、阻尼(damping)與初始速度(initialVelocity)
            .edgesIgnoringSafeArea(.all)
            //調用父view尺寸來設置view位置
            //因為是計算全螢幕尺寸，為了計算正確，所以忽略safeArea
            .gesture( //拖拽手勢
                DragGesture()
                    .updating(self.$dragState, body: {(value, state, translation) in
                        state = .dragging(translation: value.translation)
                    })
                    .onEnded({(value) in
                        switch self.viewState {
                        case .half:
                            if value.translation.height < -geometry.size.height * 0.1 {
                                //self.positionOffset = -geometry.size.height / 2 + 50
                                self.positionOffset = -geometry.size.height / 2
                                self.viewState = .top
                            }//上滑到此，view完全打開
                            if value.translation.height > geometry.size.height * 0.15 {
                                self.isShow = false
                            }//下滑到此，view關閉
                        case .top:
                            if value.translation.height > geometry.size.height * 0.1 {
                                self.positionOffset = 0
                                self.viewState = .half
                                //下滑到此，view回到半開狀態
                            }
                            if value.translation.height > geometry.size.height * 0.75 {
                                self.isShow = false
                            }//下滑到此，view關閉
                        }
                    })
            )
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(isShow: .constant(true), book: books[0])
        //HandleBar()
        //TitleBar()
        //HeadView(restaurant: restaurants[13])
        //DetailInfoView(icon: "map", info: restaurants[0].location)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
        
    }
}
//MARK: - 內容結構
struct HandleBar: View {
    var body: some View {
        Rectangle()
            .frame(width: 50, height: 5)
            .cornerRadius(10)
    }
}

struct TitleBar: View {
    var buttonSize: CGFloat = 25
    @Binding var isShow: Bool
    
    var body: some View {
        HStack() {
            Spacer()
            Text("Book Detail")
                .font(.system(.headline, design: .rounded))
                .bold()
                .padding(.leading, +buttonSize)
            Spacer()
            Button(action: {
                self.isShow = false
                    
            }, label: {
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize, alignment: .leading)
            })
            

        }.padding()
    }
}

struct HeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    let book: Book
    var body: some View {
        Image(book.image)
            .resizable()
            .scaledToFit()
            .frame(height: 300)
            .clipped()
        HStack {
            VStack{
                Text(book.name)
                    .font(.system(.title))
                    .bold()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.bottom, 1)
                Text("¥ \(book.price)")
                    .bold()
                    .background(Rectangle().frame(width: 100).foregroundColor(.orange))
                    .foregroundColor(.white)
                    .font(.system(.body, design: .rounded))
                    .frame(width: 100)
                    .cornerRadius(2)
            }
            Spacer()
        }.padding(.horizontal)
//            .overlay(
//                HStack {
//                    VStack(alignment: .leading) {
//                        Spacer()
//                        Text(book.name)
//                            .foregroundColor(.primary)
//                            .font(.system(.title, design: .rounded))
//                            .bold()
//                            //.padding(.bottom)
//                        Text(book.price)
//                            .font(.system(.headline, design: .rounded))
//                            .foregroundColor(.white)
//                            .background(Color.red)
//                            .cornerRadius(5)
//                            .padding(5)
//                    }
//                    .padding(.bottom, 5)
//                    .padding(.leading, 6)
//                    Spacer()
//                }
//            )
    }
}

struct DetailInfoView: View {
    //這是個通用組件，地址、電話和介紹唯一的區別是有沒有icon
    var icon: String?
    let info: String

    var body: some View {
        
        HStack {
            if icon != nil {
                Image(systemName: icon!)
                    .padding(.trailing, 10)
            }
            Text(info)
                .font(.system(.body, design: .rounded))
            Spacer()
        }.padding(.horizontal)
    }
}


//MARK: -拖動狀態

enum DragState {
    //拖拽狀態枚舉
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    var isDragging: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}

enum ViewState {
    case top
    case half
}
