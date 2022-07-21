//
//  Home.swift
//  UI-618
//
//  Created by nyannyan0328 on 2022/07/21.
//

import SwiftUI

struct Home: View {
    @State var hederHeight : CGFloat = 0
    @State var hederOffset : CGFloat = 0
    @State var lastHeaderOffset : CGFloat = 0
    @State var delection : swipeDelection = .non
    @State var shiftOfset : CGFloat = 0
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            
            ThumNailView()
                .padding(.top,hederHeight)
                .offsetY { previous, current in
                    
                    
                    if previous > current{
                        
                        if delection != .up && current < 0{
                            
                            shiftOfset = current - hederOffset
                            delection = .up
                            lastHeaderOffset = hederOffset
                            
                            
                        }
                        
                        let offset = current < 0 ? (current - shiftOfset) : 0
                        hederOffset = (-offset < hederHeight ? (offset < 0 ? offset : 0) : -hederHeight)
                        
                        print("UP")
                    }
                    else{
                        
                        print("DOWN")
                        
                        
                        if delection != .down{
                            
                            shiftOfset = current
                            delection = .down
                            lastHeaderOffset = hederOffset
                        }
                        
                        let offset = lastHeaderOffset + (current - shiftOfset)
                        hederOffset = (offset > 0 ? 0 : offset)
                    }
                }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment:.top) {
            
            HeaderView()
                .anchorPreference(key : HederBoudsKey.self ,value: .bounds) { $0
                }
                .overlayPreferenceValue(HederBoudsKey.self) { value in
                    
                    GeometryReader{proxy in
                        
                        if let anchor = value{
                            
                            Color.clear
                                .onAppear{
                                    
                                    hederHeight = proxy[anchor].height
                                }
                        }
                    }
                    
                }
                .offset(y:-hederOffset < hederHeight ? hederOffset : (hederOffset < 0 ? hederOffset : 0))
        }
        .ignoresSafeArea(.all,edges: .top)
    }
    @ViewBuilder
    func HeaderView()->some View{
        
        
        VStack(spacing:15){
            
            VStack(spacing:0){
                
                HStack{
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:120)
                    
                    HStack(spacing:10){
                        
                        
                        let topName : [String] = ["Notifications","Search","Shareplay"]
                        
                        ForEach(topName,id:\.self){name in
                            
                            Image(name)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray)
                                .frame(width: 20,height: 20)
                        }
                        
                        Image("Pic")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30,height: 30)
                            .clipShape(Circle())
                        
                    }
                    
                    
                    
                    
                    
                }
                
                .frame(maxWidth: .infinity,alignment: .trailing)
                
                .padding([.horizontal,.top],15)
                
                
                Divider()
                    .padding(.horizontal,-15)
                
            }
            TagView()
                .padding(.bottom,14)
        }
        .padding(.top,getSafeArea().top)
        .background{
            Color.white.ignoresSafeArea()
        }
        .padding(.bottom,20)
        
        
        
    }
    @ViewBuilder
    func TagView()->some View{
        
        ScrollView(.horizontal,showsIndicators: false){
            
            HStack(spacing:15){
                let tags = ["All","iJustine","Kavsoft","Apple","SwiftUI","Programming","Technology"]
                
                
                ForEach(tags,id:\.self){tag in
                    
                    
                    Text(tag)
                        .font(.callout)
                        .foregroundColor(.black)
                        .padding(.vertical,8)
                        .padding(.horizontal,15)
                        .background{
                         
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }
                
                
            }
        }
        
    }
    @ViewBuilder
    func ThumNailView()->some View{
        
        VStack(spacing:16){
            
            
            ForEach(0...10,id:\.self){index in
                
                GeometryReader{proxy in
                    
                     let size = proxy.size
                    
                    Image("Image\((index % 5) + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width,height: size.height)
                        .clipped()
                }
                .frame(height:250)
                    .padding(.horizontal)
                
            }
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum swipeDelection{
    
    case up
    case down
    case non
}
