; RUN: llvm-as < %s | llvm-dis | FileCheck %s
target datalayout = "p:52:64"
; CHECK: 目标 数据布局 = "p:52:64"