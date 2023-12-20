//
//  CustomNavigationBar.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/24.
//

import SwiftUI

struct CustomNavigationBar: View {
    let isDisplayLeftBtn: Bool
    let isDisplayRightBtn: Bool
    let leftBtnAction: () -> Void
    let rightBtnAction: () -> Void
    let rightBtnType: NavigationBtnType
    
    init(
        isDisplayLeftBtn: Bool = true,
        isDisplayRightBtn: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        rightBtnAction: @escaping () -> Void = {},
        rightBtnType: NavigationBtnType = .edit
    ) {
        self.isDisplayLeftBtn = isDisplayLeftBtn
        self.isDisplayRightBtn = isDisplayRightBtn
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
        self.rightBtnType = rightBtnType
    }
    
    var body: some View {
        HStack {
            if isDisplayLeftBtn {
                Button(action: leftBtnAction) {
                    Image("backButton")
                }
            }
            
            Spacer()
            
            if isDisplayRightBtn {
                Button(action: rightBtnAction) {
                    if rightBtnType == .close {
                        Image("close")
                    }
                    else {
                        Text(rightBtnType.rawValue)
                            .foregroundColor(.customBlack)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 20)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar()
    }
}
