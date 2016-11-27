//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Benny on 8/9/15.
//  Copyright (c) 2015 Benny Rodriguez. All rights reserved.
//

import Foundation

class RecorderAudio {
    
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrl : URL, title : String) {
        
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
