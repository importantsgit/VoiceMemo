//
//  Path.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/23.
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
