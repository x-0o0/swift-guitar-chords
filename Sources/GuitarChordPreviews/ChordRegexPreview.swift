//
//  ChordRegexPreview.swift
//  
//
//  Created by 이재성 on 10/19/24.
//

import SwiftUI
import GuitarChords

struct ChordRegexPreview: View {
    @State private var songMemo = """
    {0_1_0_2_3_0-C}잔잔한 당신{0_0_1_2_2_0-E}은 {1_1_2_3_3_1-F}이 맘을 넘치{0_1_0_2_3_0-C}게 하지 않을거{0_1_0_2_0_0-Am7}야
    그대로{1_1_2_3_3_1-F}도 편히 {2_1_2_0_x_x-D7}안길 수가 있으니{1_0_0_0_2_3-G7}까
    """
    
    var body: some View {
        List {
            Section {
                TextEditor(text: $songMemo)
                    .frame(height: 200)
            } header: {
                Text("Raw Text")
            }
            
            Section {
                Text(songMemo.regexedAttributedString())
                    .tint(.green)
            } header: {
                Text("Regexed")
            }
        }
    }
    
    func detect() {
        
    }
}

#Preview {
    ChordRegexPreview()
        .preferredColorScheme(.dark)
}
