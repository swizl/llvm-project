; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; Check constantexprs which ifunc looks through to find the resolver
; function.

@ifunc_addrspacecast_as1_to_as0 = ifunc void (), ptr addrspacecast (ptr addrspace(1) @resolver_as1 to ptr)

; CHECK: @alias_resolver = 内部 alias 整数32 (整数32), 指针 @resolver
@alias_resolver = internal alias i32 (i32), ptr @resolver

; CHECK: @ifunc_resolver_is_alias = 内部 ifunc 整数32 (整数32), 指针 @alias_resolver
@ifunc_resolver_is_alias = internal ifunc i32 (i32), ptr @alias_resolver


; CHECK: 定义 指针 @resolver_as1() addrspace(1) {
define ptr @resolver_as1() addrspace(1) {
  ret ptr null
}

; CHECK: 定义 内部 指针 @resolver() {
define internal ptr @resolver() {
  ret ptr null
}
