;; Check all requirements on the ptrtoaddr constant expression operands
;; Most of these invalid cases are detected at parse time but some are only
;; detected at verification time (see Verifier::visitPtrToAddrInst())
; RUN: rm -rf %t && split-file --leading-lines %s %t

;--- src_vec_dst_no_vec.ll
; RUN: not llvm-as %t/src_vec_dst_no_vec.ll -o /dev/null 2>&1 | FileCheck -check-prefix=SRC_VEC_DST_NO_VEC %s --implicit-check-not="error:"
@g = global i64 ptrtoaddr (<2 x ptr> <ptr @g, ptr @g> to i64)
; SRC_VEC_DST_NO_VEC: [[#@LINE-1]]:17: error: invalid cast opcode for cast from '<2 个 指针>' to '整数64'

;--- src_no_vec_dst_vec.ll
; RUN: not llvm-as %t/src_no_vec_dst_vec.ll -o /dev/null 2>&1 | FileCheck -check-prefix=SRC_NO_VEC_DST_VEC %s --implicit-check-not="error:"
@g = global <2 x i64> ptrtoaddr (ptr @g to <2 x i64>)
; SRC_NO_VEC_DST_VEC: [[#@LINE-1]]:23: error: invalid cast opcode for cast from '指针' to '<2 个 整数64>'

;--- dst_not_int.ll
; RUN: not llvm-as %t/dst_not_int.ll -o /dev/null 2>&1 | FileCheck -check-prefix=DST_NOT_INT %s --implicit-check-not="error:"
@g = global float ptrtoaddr (ptr @g to float)
; DST_NOT_INT: [[#@LINE-1]]:19: error: invalid cast opcode for cast from '指针' to '单精度'

;--- dst_not_int_vec.ll
; RUN: not llvm-as %t/dst_not_int_vec.ll -o /dev/null 2>&1 | FileCheck -check-prefix=DST_NOT_INT_VEC %s --implicit-check-not="error:"
@g = global <2 x float> ptrtoaddr (<2 x ptr> <ptr @g, ptr @g> to <2 x float>)
; DST_NOT_INT_VEC: [[#@LINE-1]]:25: error: invalid cast opcode for cast from '<2 个 指针>' to '<2 个 单精度>'

;--- src_not_ptr.ll
; RUN: not llvm-as %t/src_not_ptr.ll -o /dev/null 2>&1 | FileCheck -check-prefix=SRC_NOT_PTR %s --implicit-check-not="error:"
@g = global i64 ptrtoaddr (i32 1 to i64)
; SRC_NOT_PTR: [[#@LINE-1]]:17: error: invalid cast opcode for cast from '整数32' to '整数64'

;--- src_not_ptr_vec.ll
; RUN: not llvm-as %t/src_not_ptr_vec.ll -o /dev/null 2>&1 | FileCheck -check-prefix=SRC_NOT_PTR_VEC %s --implicit-check-not="error:"
@g = global <2 x i64> ptrtoaddr (<2 x i32> <i32 1, i32 2> to <2 x i64>)
; SRC_NOT_PTR_VEC: [[#@LINE-1]]:23: error: invalid cast opcode for cast from '<2 个 整数32>' to '<2 个 整数64>'

;--- vec_src_fewer_elems.ll
; RUN: not llvm-as %t/vec_src_fewer_elems.ll -o /dev/null 2>&1 | FileCheck -check-prefix=VEC_SRC_FEWER_ELEMS %s --implicit-check-not="error:"
@g = global <4 x i64> ptrtoaddr (<2 x ptr> <ptr @g, ptr @g> to <4 x i64>)
; VEC_SRC_FEWER_ELEMS: [[#@LINE-1]]:23: error: invalid cast opcode for cast from '<2 个 指针>' to '<4 个 整数64>'

;--- vec_dst_fewer_elems.ll
; RUN: not llvm-as %t/vec_dst_fewer_elems.ll -o /dev/null 2>&1 | FileCheck -check-prefix=VEC_DST_FEWER_ELEMS %s --implicit-check-not="error:"
@g = global <2 x i64> ptrtoaddr (<4 x ptr> <ptr @g, ptr @g, ptr @g, ptr @g> to <2 x i64>)
; VEC_DST_FEWER_ELEMS: [[#@LINE-1]]:23: error: invalid cast opcode for cast from '<4 个 指针>' to '<2 个 整数64>'

;--- dst_not_addr_size.ll
; The following invalid IR is caught by the verifier, not the parser:
; RUN: llvm-as %t/dst_not_addr_size.ll --disable-output --disable-verify
; RUN: not llvm-as %t/dst_not_addr_size.ll -o /dev/null 2>&1 | FileCheck -check-prefix=DST_NOT_ADDR_SIZE %s --implicit-check-not="error:"
; DST_NOT_ADDR_SIZE: assembly parsed, but does not verify as correct!
@g = global i32 ptrtoaddr (ptr @g to i32)
; DST_NOT_ADDR_SIZE-NEXT: PtrToAddr result must be address width
; DST_NOT_ADDR_SIZE-NEXT: 整数32 指针转地址 (指针 @g 到 整数32)
@g_vec = global <4 x i32> ptrtoaddr (<4 x ptr> <ptr @g_vec, ptr @g_vec, ptr @g_vec, ptr @g_vec> to <4 x i32>)
; DST_NOT_ADDR_SIZE-NEXT: PtrToAddr result must be address width
; DST_NOT_ADDR_SIZE-NEXT: 整数32 指针转地址 (指针 @g_vec 到 整数32)

;--- dst_not_addr_size_in_inst.ll
; RUN: not llvm-as %t/dst_not_addr_size_in_inst.ll -o /dev/null 2>&1 | FileCheck -check-prefix=DST_NOT_ADDR_SIZE_IN_INST %s --implicit-check-not="error:"
; DST_NOT_ADDR_SIZE_IN_INST: PtrToAddr result must be address width
; DST_NOT_ADDR_SIZE_IN_INST-NEXT: 整数32 指针转地址 (指针 @fn 到 整数32)
define i32 @fn() {
    ret i32 ptrtoaddr (ptr @fn to i32)
}

; DST_NOT_ADDR_SIZE_IN_INST: PtrToAddr result must be address width
; DST_NOT_ADDR_SIZE_IN_INST-NEXT: 整数32 指针转地址 (指针 @fn2 到 整数32)
define <2 x i32> @fn2() {
    ret <2 x i32> <i32 ptrtoaddr (ptr @fn2 to i32), i32 ptrtoaddr (ptr @fn2 to i32)>
}
