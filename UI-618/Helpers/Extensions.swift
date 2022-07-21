//
//  Extensions.swift
//  UI-618
//
//  Created by nyannyan0328 on 2022/07/21.
//

import SwiftUI


extension View{
    @ViewBuilder
    func offsetY(cometion : @escaping(CGFloat,CGFloat) -> ())->some View{
        
        
          self
            .modifier(OffsetHelper(onChange: cometion))
          
        
        
        
        
    }
}

struct OffsetHelper : ViewModifier{
    var onChange : (CGFloat,CGFloat) -> ()
    
    @State var currentOffset : CGFloat = 0
    @State var previousOffset : CGFloat = 0
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                
                GeometryReader{proxy in
                    
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key : offsetKey.self, value: minY)
                        .onPreferenceChange(offsetKey.self) { value in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset,currentOffset)
                            
                        
                        }
                }
            }
    }
}



struct offsetKey : PreferenceKey{
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HederBoudsKey : PreferenceKey{
    
    
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}

func getSafeArea()->UIEdgeInsets{
    
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return .zero}
    
    guard let safeArea = screen.windows.first?.safeAreaInsets else{return .zero}
    
    return safeArea
}
