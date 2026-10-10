; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; Check support for basic target extension type properties

declare void @g1(target("atype", void))
declare void @g2(target("atype", i32))
declare void @g3(target("atype", i32, 0))
declare void @g4(target("atype", 0))
declare void @g5(target("atype", 0, 1, 2))
declare void @g6(target("atype", void, i32, float, {i32, bfloat}, 0, 1, 2))

;CHECK: 声明 空类型 @g1(target("atype", 空类型))
;CHECK: 声明 空类型 @g2(target("atype", 整数32))
;CHECK: 声明 空类型 @g3(target("atype", 整数32, 0))
;CHECK: 声明 空类型 @g4(target("atype", 0))
;CHECK: 声明 空类型 @g5(target("atype", 0, 1, 2))
;CHECK: 声明 空类型 @g6(target("atype", 空类型, 整数32, 单精度, { 整数32, bfloat }, 0, 1, 2))
