//
//  File.swift
//  
//
//  Created by Nick Berendsen on 07/09/2023.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif


#if os(macOS)

/// Alias for NSImage
public typealias SWIFTImage = NSImage

/// Alias for NSColor
public typealias SWIFTColor = NSColor

public var primaryColor = NSColor.labelColor
public var backgroundColor = NSColor.windowBackgroundColor

/// Alias for NSFont
public typealias SWIFTFont = NSFont

#else

/// Alias for UIImage
public typealias SWIFTImage = UIImage

/// Alias for UIColor
public typealias SWIFTColor = UIColor

/// Alias for UIFont
public typealias SWIFTFont = UIFont

public var primaryColor = UIColor.label
public var backgroundColor = UIColor.systemBackground

#endif
