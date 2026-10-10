; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

; Test that global aliases are allowed to be constant addrspacecast

@i = internal addrspace(1) global i8 42
@ia = internal alias ptr addrspace(2), addrspacecast (ptr addrspace(1) @i to ptr addrspace(3))
; CHECK: @ia = 内部 alias 指针 addrspace(2), 地址空间转换 (指针 addrspace(1) @i 到 指针 addrspace(3))
