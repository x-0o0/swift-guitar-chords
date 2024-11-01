//
//  Scope.swift
//  swift-guitar-chords
//
//  Created by 이재성 on 11/1/24.
//

extension GuitarChord {
    public enum Scope: Hashable {
        /// GuitarChords 에 의해 관리되는 기본 저장 영역
        case service
        case custom(String)
    }
}
