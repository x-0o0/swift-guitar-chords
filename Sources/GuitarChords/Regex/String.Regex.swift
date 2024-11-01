//
//  String.Regex.swift
//  
//
//  Created by 이재성 on 10/19/24.
//

import Foundation

extension String {
    /// ```swift
    /// let text = """
    /// {0_1_0_2_3_0-C} 잔잔한 당신{0_0_1_2_2_0-E}은
    /// {1_1_2_3_3_1-F}이 맘을 넘치{0_1_0_2_3_0-C}게
    /// 하지 않을거{0_1_0_2_0_0-Am7}야
    /// """
    /// print(text.regexedAttributedString())
    /// // C 잔잔한 당신E은
    /// // F이 맘을 넘치C게
    /// // 하지 않을거Am7야
    ///
    /// // 🔗 각각의 코드는 `"guitarchord://{id}`의 링크 버튼
    /// ```
    public func regexedAttributedString() -> AttributedString {
        var attributedString = AttributedString(self)
        
        guard let regex = try? NSRegularExpression(pattern: Chord.pattern, options: []) else { return attributedString }
        let range = NSRange(self.startIndex..<self.endIndex, in: self)
        // 정규 표현식에 매칭되는 모든 결과
        let matchingResults = regex.matches(in: self, options: [], range: range)
        // 매칭 결과를 역순으로 처리하여 문자열 교체
        matchingResults.reversed().forEach {
            guard $0.numberOfRanges == 3 else { return }
            guard let fretStringRange = Range($0.range(at: 1), in: self) else { return }
            guard let chordNameRange = Range($0.range(at: 2), in: self) else { return }
            
            // fretString
            let fretString = String(self[fretStringRange])
            // chord name
            let chordName = String(self[chordNameRange])
            
            guard let fullMatchingRange = Range($0.range, in: self) else { return }
            guard let attributedRange = attributedString.range(from: fullMatchingRange, in: self) else { return }
            
            var chordText = AttributedString(chordName)
            var linkAttributes = AttributeContainer()
            linkAttributes.link = URL(string: "guitarchord://\(fretString)")
            chordText.setAttributes(linkAttributes)
            
            attributedString.replaceSubrange(attributedRange, with: chordText)
        }
        
        return attributedString
    }
}

// String.Index를 AttributedString.Index로 변환하는 확장 함수
extension AttributedString {
    func range(from nsRange: Range<String.Index>, in original: String) -> Range<AttributedString.Index>? {
        guard let start = AttributedString.Index(nsRange.lowerBound, within: self) else { return nil }
        guard let end = AttributedString.Index(nsRange.upperBound, within: self) else { return nil }
        return start..<end
    }
}
