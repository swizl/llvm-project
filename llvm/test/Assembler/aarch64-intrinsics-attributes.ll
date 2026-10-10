; REQUIRES: aarch64-registered-target

; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; Make sure some AArch64 intrinsics have the expected attributes.

; CHECK: 声明 整数64 @llvm.aarch64.ldxr.p0(指针) [[NOFREE_NOUNWIND_WILLRETURN:#[0-9]+]]
declare i64 @llvm.aarch64.ldxr.p0(ptr)

; CHECK: 声明 整数32 @llvm.aarch64.stxp(整数64, 整数64, 指针) [[NOFREE_NOUNWIND_WILLRETURN]]
declare i32 @llvm.aarch64.stxp(i64, i64, ptr)

; CHECK: 声明 空类型 @llvm.aarch64.dsb(整数32) [[NOFREE_NOUNWIND_WILLRETURN]]
declare void @llvm.aarch64.dsb(i32)

; CHECK: 声明 整数64 @llvm.aarch64.neon.sqdmulls.scalar(整数32, 整数32) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_READNONE_WILLRETURN:#[0-9]+]]
declare i64 @llvm.aarch64.neon.sqdmulls.scalar(i32, i32)

; CHECK: 声明 <4 个 整数32> @llvm.aarch64.neon.shadd.v4i32(<4 个 整数32>, <4 个 整数32>) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_READNONE_WILLRETURN]]
declare <4 x i32> @llvm.aarch64.neon.shadd.v4i32(<4 x i32>, <4 x i32>)

; CHECK: 声明 <vscale x 4 个 整数32> @llvm.aarch64.sve.dup.nxv4i32(<vscale x 4 个 整数32>, <vscale x 4 个 整数1>, 整数32) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_SPECULATABLE_READNONE_WILLRETURN:#[0-9]+]]
declare <vscale x 4 x i32> @llvm.aarch64.sve.dup.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i1>, i32)

; CHECK: 声明 空类型 @llvm.aarch64.neon.st2.v4i32.p0(<4 个 整数32>, <4 个 整数32>, 指针 captures(none)) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_WRITEONLY_WILLRETURN:#[0-9]+]]
declare void @llvm.aarch64.neon.st2.v4i32.p0(<4 x i32>, <4 x i32>, ptr)

; CHECK: 声明 空类型 @llvm.aarch64.neon.st2lane.v4i32.p0(<4 个 整数32>, <4 个 整数32>, 整数64, 指针 captures(none)) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_WRITEONLY_WILLRETURN:#[0-9]+]]
declare void @llvm.aarch64.neon.st2lane.v4i32.p0(<4 x i32>, <4 x i32>, i64, ptr)

; CHECK: 声明 空类型 @llvm.aarch64.neon.st1x2.v8i16.p0(<8 个 整数16>, <8 个 整数16>, 指针 captures(none)) [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_WRITEONLY_WILLRETURN:#[0-9]+]]
declare void @llvm.aarch64.neon.st1x2.v8i16.p0(<8 x i16>, <8 x i16>, ptr)

; CHECK: attributes [[NOFREE_NOUNWIND_WILLRETURN]] = { nofree nounwind willreturn }
; CHECK: attributes [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_READNONE_WILLRETURN]] = { nocallback nofree nosync nounwind willreturn memory(none) }
; CHECK: attributes [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_SPECULATABLE_READNONE_WILLRETURN]] = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
; CHECK: attributes [[NO_CALLBACK_NOFREE_NOSYNC_NOUNWIND_WRITEONLY_WILLRETURN]] = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
