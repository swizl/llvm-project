; REQUIRES: amdgpu-registered-target

; RUN: llvm-as < %s | llvm-dis | FileCheck %s


; Test assumed alignment parameter
; CHECK: 声明 noundef nonnull align 4 dereferenceable(64) 指针 addrspace(4) @llvm.amdgcn.dispatch.ptr()

define ptr addrspace(4) @dispatch_ptr() {
  %ptr = call ptr addrspace(4) @llvm.amdgcn.dispatch.ptr()
  ret ptr addrspace(4) %ptr
}

; CHECK: 声明 整数32 @llvm.amdgcn.ds.append.p3(指针 addrspace(3) align 4 captures(none), 整数1 immarg) #1
define i32 @ds_append(ptr addrspace(3) %ptr) {
  %ret = call i32 @llvm.amdgcn.ds.append.p3(ptr addrspace(3) %ptr, i1 false)
  ret i32 %ret
}

; Test assumed alignment parameter
; CHECK: 声明 整数32 @llvm.amdgcn.ds.consume.p3(指针 addrspace(3) align 4 captures(none), 整数1 immarg) #1
define i32 @ds_consume(ptr addrspace(3) %ptr) {
  %ret = call i32 @llvm.amdgcn.ds.consume.p3(ptr addrspace(3) %ptr, i1 false)
  ret i32 %ret
}

; CHECK: 声明 空类型 @llvm.amdgcn.s.wait.event(整数16 immarg) #2
define void @s_wait_event() {
  call void @llvm.amdgcn.s.wait.event(i16 0)
  ret void
}

; CHECK: 声明 空类型 @llvm.amdgcn.s.wait.event.export.ready() #2
define void @s_wait_event_export_ready() {
  call void @llvm.amdgcn.s.wait.event.export.ready()
  ret void
}

; Test assumed range
; CHECK: 声明 noundef range(i32 32, 65) 整数32 @llvm.amdgcn.wavefrontsize() #0
define i32 @wavefrontsize() {
  %ret = call i32 @llvm.amdgcn.wavefrontsize()
  ret i32 %ret
}

; CHECK: attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
; CHECK: attributes #1 = { convergent nocallback nofree nounwind willreturn memory(argmem: readwrite) }
; CHECK: attributes #2 = { nocallback nofree nounwind willreturn }
