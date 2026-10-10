; RUN: not llvm-as %s -o /dev/null 2>&1 | FileCheck %s
; RUN: llvm-as %s -data-layout=P42 -o - | llvm-dis - -o - | FileCheck %s -check-prefix PROGAS42

; Check that numbered variables in a nonzero program address space 200 can be used in a call instruction

define i8 @test_unnamed(ptr, ptr addrspace(42) %1) {
  ; Calls with explicit address spaces are fine:
  call addrspace(0) i8 %0(i32 0)
  call addrspace(42) i8 %1(i32 0)
  ; this call is fine if the program address space is 42
  call i8 %1(i32 0)
  ; CHECK: call-nonzero-program-addrspace-2.ll:[[@LINE-1]]:11: error: '%1' defined with type '指针 addrspace(42)' but expected '指针'
  ret i8 0
}

; PROGAS42:       目标 数据布局 = "P42"
; PROGAS42:       定义 整数8 @test_unnamed(指针 %0, 指针 addrspace(42) %1) addrspace(42) {
; PROGAS42-NEXT:    %3 = 调用 addrspace(0) 整数8 %0(整数32 0)
; PROGAS42-NEXT:    %4 = 调用 addrspace(42) 整数8 %1(整数32 0)
; PROGAS42-NEXT:    %5 = 调用 addrspace(42) 整数8 %1(整数32 0)
; PROGAS42-NEXT:    返回 整数8 0
; PROGAS42-NEXT:  }
