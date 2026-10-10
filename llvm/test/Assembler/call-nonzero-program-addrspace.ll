; RUN: not llvm-as %s -o /dev/null 2>&1 | FileCheck %s
; RUN: llvm-as %s -data-layout=P42 -o - | llvm-dis - -o - | FileCheck %s -check-prefix PROGAS42

; Check that variables in a nonzero program address space 42 can be used in a call instruction

define i8 @test(ptr %fnptr0, ptr addrspace(42) %fnptr42) {
  %explicit_as_0 = call addrspace(0) i8 %fnptr0(i32 0)
  %explicit_as_42 = call addrspace(42) i8 %fnptr42(i32 0)
  ; Calling %fnptr42 without an explicit addrspace() in the call instruction is only okay if the program AS is 42
  %call_no_as = call i8 %fnptr42(i32 0)
  ; CHECK: call-nonzero-program-addrspace.ll:[[@LINE-1]]:25: error: '%fnptr42' defined with type '指针 addrspace(42)' but expected '指针'
  ret i8 0
}

; PROGAS42:       目标 数据布局 = "P42"
; PROGAS42:       定义 整数8 @test(指针 %fnptr0, 指针 addrspace(42) %fnptr42) addrspace(42) {
; Print addrspace(0) since the program address space is non-zero:
; PROGAS42-NEXT:    %explicit_as_0 = 调用 addrspace(0) 整数8 %fnptr0(整数32 0)
; Also print addrspace(42) since we always print non-zero addrspace:
; PROGAS42-NEXT:    %explicit_as_42 = 调用 addrspace(42) 整数8 %fnptr42(整数32 0)
; PROGAS42-NEXT:    %call_no_as = 调用 addrspace(42) 整数8 %fnptr42(整数32 0)
; PROGAS42-NEXT:    返回 整数8 0
; PROGAS42-NEXT:  }
