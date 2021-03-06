//
//  CGSizeOperations.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 14/07/16.
//

import UIKit

// MARK: CGSize Operators

func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width,
                  height: left.height + right.height);
}

func += ( left: inout CGSize, right: CGSize) {
    left = left + right;
}


// Returns a CGSize composed by the addition of the width of two CGSize and the higher height
infix operator +> { associativity left precedence 140 }
func +> (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width,
                  height: max(left.height, right.height));
}

infix operator +>= { associativity right precedence 90 }
func +>= ( left: inout CGSize, right: CGSize) {
    left = left +> right;
}


// Returns a CGSize composed by the higher width of two GCsize and the addition of their heights
infix operator +^ { associativity left precedence 140 }
func +^ (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: max(left.width, right.width),
                  height: left.height + right.height);
}

infix operator +^= { associativity right precedence 90 }
func +^= ( left: inout CGSize, right: CGSize) {
    left = left +^ right;
}
