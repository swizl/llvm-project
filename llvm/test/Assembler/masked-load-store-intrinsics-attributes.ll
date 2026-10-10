; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; Make sure some masked/load store intrinsics have the expected attributes
; Specifically `captures(none)' should be added to the pointer parameters for
; the loads/stores

; CHECK: 声明 <vscale x 2 个 整数64> @llvm.masked.load.nxv2i64.p0(指针 captures(none), <vscale x 2 个 整数1>, <vscale x 2 个 整数64>) [[ARGMEMONLY_NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_READONLY_WILLRETURN:#[0-9]+]]
declare <vscale x 2 x i64> @llvm.masked.load.nxv2i64.p0(ptr, <vscale x 2 x i1>, <vscale x 2 x i64>)

; CHECK: 声明 空类型 @llvm.masked.store.nxv2i64.p0(<vscale x 2 个 整数64>, 指针 captures(none), <vscale x 2 个 整数1>) [[ARGMEMONLY_NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_WILLRETURN_WRITEONLY:#[0-9]+]]
declare void @llvm.masked.store.nxv2i64.p0(<vscale x 2 x i64>, ptr, <vscale x 2 x i1>)

; CHECK: 声明 <16 个 单精度> @llvm.masked.expandload.v16f32.p0(指针 captures(none), <16 个 整数1>, <16 个 单精度>) [[NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_READONLY_WILLRETURN:#[0-9]+]]
declare <16 x float> @llvm.masked.expandload.v16f32.p0(ptr, <16 x i1>, <16 x float>)

; CHECK: 声明 空类型 @llvm.masked.compressstore.v8i32.p0(<8 个 整数32>, 指针 captures(none), <8 个 整数1>) [[ARGMEMONLY_NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_WILLRETURN_WRITEONLY:#[0-9]+]]
declare void @llvm.masked.compressstore.v8i32.p0(<8 x i32>, ptr, <8  x i1>)

; CHECK: attributes [[ARGMEMONLY_NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_READONLY_WILLRETURN]] = { nocallback nofree nosync nounwind willreturn memory(argmem: read) }
; CHECK: attributes [[ARGMEMONLY_NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_WILLRETURN_WRITEONLY]] = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
; CHECK: attributes [[NOCALLBACK_NOFREE_NOSYNC_NOUNWIND_READONLY_WILLRETURN]] = { nocallback nofree nosync nounwind willreturn memory(read) }
