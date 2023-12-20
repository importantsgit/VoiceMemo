//
//  PathType.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/23.
//

import Foundation

enum PathType: Hashable {
    case homeView
    case todoView
    case memoView(isCreateMode: Bool, memo: Memo?)
}
