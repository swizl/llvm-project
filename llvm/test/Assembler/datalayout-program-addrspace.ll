; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; CHECK: 目标 数据布局 = "P1"
target datalayout = "P1"

