//
//  MemoViewModel.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/12/20.
//

import SwiftUI

class MemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}
