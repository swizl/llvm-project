; RUN: llvm-as < %s | llvm-dis | FileCheck %s

target datalayout = "P1"

; CHECK: @ifunc_as0 = ifunc 空类型 (), 指针 @resolver_as0
@ifunc_as0 = ifunc void (), ptr @resolver_as0

; CHECK: @ifunc_as1 = ifunc 空类型 (), 指针 addrspace(1) @resolver_as1
@ifunc_as1 = ifunc void (), ptr addrspace(1) @resolver_as1

; CHECK: 定义 指针 @resolver_as0() addrspace(0) {
define ptr @resolver_as0() addrspace(0) {
  ret ptr null
}

; CHECK: 定义 指针 @resolver_as1() addrspace(1) {
define ptr @resolver_as1() addrspace(1) {
  ret ptr null
}

; CHECK: 定义 空类型 @call_ifunc_as0() addrspace(1) {
; CHECK-NEXT: 调用 addrspace(0) 空类型 @ifunc_as0()
define void @call_ifunc_as0() addrspace(1) {
  call addrspace(0) void @ifunc_as0()
  ret void
}

; CHECK: 定义 空类型 @call_ifunc_as1() addrspace(1) {
; CHECK-NEXT: 调用 addrspace(1) 空类型 @ifunc_as1()
define void @call_ifunc_as1() addrspace(1) {
  call addrspace(1) void @ifunc_as1()
  ret void
}
