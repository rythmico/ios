// MIT License
//
// Copyright (c) 2020 Point-Free, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// https://github.com/pointfreeco/swift-composable-architecture/blob/3c51885b983b623f0cc506660d79b02d45a8ffc1/Sources/ComposableArchitecture/SwiftUI/SwitchStore.swift#L1199-L1215

public func enumTag<Case>(_ `case`: Case) -> UInt32? {
    let metadataPtr = unsafeBitCast(type(of: `case`), to: UnsafeRawPointer.self)
    let kind = metadataPtr.load(as: Int.self)
    let isEnumOrOptional = kind == 0x201 || kind == 0x202
    guard isEnumOrOptional else { return nil }
    let vwtPtr = (metadataPtr - MemoryLayout<UnsafeRawPointer>.size).load(as: UnsafeRawPointer.self)
    let vwt = vwtPtr.load(as: EnumValueWitnessTable.self)
    return withUnsafePointer(to: `case`) { vwt.getEnumTag($0, metadataPtr) }
}

private struct EnumValueWitnessTable {
    let f1, f2, f3, f4, f5, f6, f7, f8: UnsafeRawPointer
    let f9, f10: Int
    let f11, f12: UInt32
    let getEnumTag: @convention(c) (UnsafeRawPointer, UnsafeRawPointer) -> UInt32
    let f13, f14: UnsafeRawPointer
}
