; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; RUN: verify-uselistorder %s

@addr = external global i64
@addr_as1 = external addrspace(1) global i64

define i64 @add_unsigned(i64 %x, i64 %y) {
; CHECK: %z = 加 nuw 整数64 %x, %y
	%z = add nuw i64 %x, %y
	ret i64 %z
}

define i64 @sub_unsigned(i64 %x, i64 %y) {
; CHECK: %z = 减 nuw 整数64 %x, %y
	%z = sub nuw i64 %x, %y
	ret i64 %z
}

define i64 @mul_unsigned(i64 %x, i64 %y) {
; CHECK: %z = 乘 nuw 整数64 %x, %y
	%z = mul nuw i64 %x, %y
	ret i64 %z
}

define i64 @add_signed(i64 %x, i64 %y) {
; CHECK: %z = 加 nsw 整数64 %x, %y
	%z = add nsw i64 %x, %y
	ret i64 %z
}

define i64 @sub_signed(i64 %x, i64 %y) {
; CHECK: %z = 减 nsw 整数64 %x, %y
	%z = sub nsw i64 %x, %y
	ret i64 %z
}

define i64 @mul_signed(i64 %x, i64 %y) {
; CHECK: %z = 乘 nsw 整数64 %x, %y
	%z = mul nsw i64 %x, %y
	ret i64 %z
}

define i64 @add_plain(i64 %x, i64 %y) {
; CHECK: %z = 加 整数64 %x, %y
	%z = add i64 %x, %y
	ret i64 %z
}

define i64 @sub_plain(i64 %x, i64 %y) {
; CHECK: %z = 减 整数64 %x, %y
	%z = sub i64 %x, %y
	ret i64 %z
}

define i64 @mul_plain(i64 %x, i64 %y) {
; CHECK: %z = 乘 整数64 %x, %y
	%z = mul i64 %x, %y
	ret i64 %z
}

define i64 @add_both(i64 %x, i64 %y) {
; CHECK: %z = 加 nuw nsw 整数64 %x, %y
	%z = add nuw nsw i64 %x, %y
	ret i64 %z
}

define i64 @sub_both(i64 %x, i64 %y) {
; CHECK: %z = 减 nuw nsw 整数64 %x, %y
	%z = sub nuw nsw i64 %x, %y
	ret i64 %z
}

define i64 @mul_both(i64 %x, i64 %y) {
; CHECK: %z = 乘 nuw nsw 整数64 %x, %y
	%z = mul nuw nsw i64 %x, %y
	ret i64 %z
}

define i64 @add_both_reversed(i64 %x, i64 %y) {
; CHECK: %z = 加 nuw nsw 整数64 %x, %y
	%z = add nsw nuw i64 %x, %y
	ret i64 %z
}

define i64 @sub_both_reversed(i64 %x, i64 %y) {
; CHECK: %z = 减 nuw nsw 整数64 %x, %y
	%z = sub nsw nuw i64 %x, %y
	ret i64 %z
}

define i64 @mul_both_reversed(i64 %x, i64 %y) {
; CHECK: %z = 乘 nuw nsw 整数64 %x, %y
	%z = mul nsw nuw i64 %x, %y
	ret i64 %z
}

define i64 @shl_both(i64 %x, i64 %y) {
; CHECK: %z = 左移 nuw nsw 整数64 %x, %y
	%z = shl nuw nsw i64 %x, %y
	ret i64 %z
}

define i64 @sdiv_exact(i64 %x, i64 %y) {
; CHECK: %z = 有符号除 exact 整数64 %x, %y
	%z = sdiv exact i64 %x, %y
	ret i64 %z
}

define i64 @sdiv_plain(i64 %x, i64 %y) {
; CHECK: %z = 有符号除 整数64 %x, %y
	%z = sdiv i64 %x, %y
	ret i64 %z
}

define i64 @udiv_exact(i64 %x, i64 %y) {
; CHECK: %z = 无符号除 exact 整数64 %x, %y
	%z = udiv exact i64 %x, %y
	ret i64 %z
}

define i64 @udiv_plain(i64 %x, i64 %y) {
; CHECK: %z = 无符号除 整数64 %x, %y
	%z = udiv i64 %x, %y
	ret i64 %z
}

define i64 @ashr_plain(i64 %x, i64 %y) {
; CHECK: %z = 算术右移 整数64 %x, %y
	%z = ashr i64 %x, %y
	ret i64 %z
}

define i64 @ashr_exact(i64 %x, i64 %y) {
; CHECK: %z = 算术右移 exact 整数64 %x, %y
	%z = ashr exact i64 %x, %y
	ret i64 %z
}

define i64 @lshr_plain(i64 %x, i64 %y) {
; CHECK: %z = 逻辑右移 整数64 %x, %y
	%z = lshr i64 %x, %y
	ret i64 %z
}

define i64 @lshr_exact(i64 %x, i64 %y) {
; CHECK: %z = 逻辑右移 exact 整数64 %x, %y
	%z = lshr exact i64 %x, %y
	ret i64 %z
}

define ptr @gep_nw(ptr %p, i64 %x) {
; CHECK: %z = 获取元素指针 inbounds 整数64, 指针 %p, 整数64 %x
	%z = getelementptr inbounds i64, ptr %p, i64 %x
        ret ptr %z
}

define ptr @gep_plain(ptr %p, i64 %x) {
; CHECK: %z = 获取元素指针 整数64, 指针 %p, 整数64 %x
	%z = getelementptr i64, ptr %p, i64 %x
        ret ptr %z
}

define i64 @add_both_ce() {
; CHECK: 返回 整数64 加 nuw nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 add nsw nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @sub_both_ce() {
; CHECK: 返回 整数64 减 nuw nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 sub nsw nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define ptr @gep_nw_ce() {
; CHECK: 返回 指针 获取元素指针 inbounds (整数64, 指针 @addr, 整数64 171)
        ret ptr getelementptr inbounds (i64, ptr @addr, i64 171)
}

define i64 @add_plain_ce() {
; CHECK: 返回 整数64 加 (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 add (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @sub_plain_ce() {
; CHECK: 返回 整数64 减 (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 sub (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define ptr @gep_plain_ce() {
; CHECK: 返回 指针 获取元素指针 (整数64, 指针 @addr, 整数64 171)
        ret ptr getelementptr (i64, ptr @addr, i64 171)
}

define i64 @add_both_reversed_ce() {
; CHECK: 返回 整数64 加 nuw nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 add nsw nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @sub_both_reversed_ce() {
; CHECK: 返回 整数64 减 nuw nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 sub nsw nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @add_signed_ce() {
; CHECK: 返回 整数64 加 nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 add nsw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @sub_signed_ce() {
; CHECK: 返回 整数64 减 nsw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 sub nsw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @add_unsigned_ce() {
; CHECK: 返回 整数64 加 nuw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 add nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @sub_unsigned_ce() {
; CHECK: 返回 整数64 减 nuw (整数64 指针转整数 (指针 @addr 到 整数64), 整数64 91)
	ret i64 sub nuw (i64 ptrtoint (ptr @addr to i64), i64 91)
}

define i64 @test_zext(i32 %a) {
; CHECK: %res = 零扩展 nneg 整数32 %a 到 整数64
  %res = zext nneg i32 %a to i64
  ret i64 %res
}

define float @test_uitofp(i32 %a) {
; CHECK: %res = 无符号转浮点 nneg 整数32 %a 到 单精度
  %res = uitofp nneg i32 %a to float
  ret float %res
}


define i64 @test_or(i64 %a, i64 %b) {
; CHECK: %res = 或 disjoint 整数64 %a, %b
  %res = or disjoint i64 %a, %b
  ret i64 %res
}

define i32 @test_trunc_signed(i64 %a) {
; CHECK: %res = 截断 nsw 整数64 %a 到 整数32
  %res = trunc nsw i64 %a to i32
  ret i32 %res
}

define i32 @test_trunc_unsigned(i64 %a) {
; CHECK: %res = 截断 nuw 整数64 %a 到 整数32
  %res = trunc nuw i64 %a to i32
  ret i32 %res
}

define i32 @test_trunc_both(i64 %a) {
; CHECK: %res = 截断 nuw nsw 整数64 %a 到 整数32
  %res = trunc nuw nsw i64 %a to i32
  ret i32 %res
}

define i32 @test_trunc_both_reversed(i64 %a) {
; CHECK: %res = 截断 nuw nsw 整数64 %a 到 整数32
  %res = trunc nsw nuw i64 %a to i32
  ret i32 %res
}

define <2 x i32> @test_trunc_signed_vector(<2 x i64> %a) {
; CHECK: %res = 截断 nsw <2 个 整数64> %a 到 <2 个 整数32>
  %res = trunc nsw <2 x i64> %a to <2 x i32>
  ret <2 x i32> %res
}

define <2 x i32> @test_trunc_unsigned_vector(<2 x i64> %a) {
; CHECK: %res = 截断 nuw <2 个 整数64> %a 到 <2 个 整数32>
  %res = trunc nuw <2 x i64> %a to <2 x i32>
  ret <2 x i32> %res
}

define <2 x i32> @test_trunc_both_vector(<2 x i64> %a) {
; CHECK: %res = 截断 nuw nsw <2 个 整数64> %a 到 <2 个 整数32>
  %res = trunc nuw nsw <2 x i64> %a to <2 x i32>
  ret <2 x i32> %res
}

define <2 x i32> @test_trunc_both_reversed_vector(<2 x i64> %a) {
; CHECK: %res = 截断 nuw nsw <2 个 整数64> %a 到 <2 个 整数32>
  %res = trunc nsw nuw <2 x i64> %a to <2 x i32>
  ret <2 x i32> %res
}

define i1 @test_icmp_samesign(i32 %a, i32 %b) {
  ; CHECK: %res = 整数比较 samesign ult 整数32 %a, %b
  %res = icmp samesign ult i32 %a, %b
  ret i1 %res
}

define <2 x i1> @test_icmp_samesign2(<2 x i32> %a, <2 x i32> %b) {
  ; CHECK: %res = 整数比较 samesign ult <2 个 整数32> %a, %b
  %res = icmp samesign ult <2 x i32> %a, %b
  ret <2 x i1> %res
}

define ptr @gep_nuw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 nuw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr nuw i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr @gep_inbounds_nuw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 inbounds nuw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr inbounds nuw i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr @gep_nusw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 nusw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr nusw i8, ptr %p, i64 %idx
  ret ptr %gep
}

; inbounds implies nusw, so the flag is not printed back.
define ptr @gep_inbounds_nusw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 inbounds 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr inbounds nusw i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr @gep_nusw_nuw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 nusw nuw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr nusw nuw i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr @gep_inbounds_nusw_nuw(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 inbounds nuw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr inbounds nusw nuw i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr @gep_nuw_nusw_inbounds(ptr %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 inbounds nuw 整数8, 指针 %p, 整数64 %idx
  %gep = getelementptr nuw nusw inbounds i8, ptr %p, i64 %idx
  ret ptr %gep
}

define ptr addrspace(1) @gep_nusw_nuw_as1(ptr addrspace(1) %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 nusw nuw 整数8, 指针 addrspace(1) %p, 整数64 %idx
  %gep = getelementptr nusw nuw i8, ptr addrspace(1) %p, i64 %idx
  ret ptr addrspace(1) %gep
}

define <2 x ptr> @gep_nusw_nuw_vec(<2 x ptr> %p, i64 %idx) {
; CHECK: %gep = 获取元素指针 nusw nuw 整数8, <2 个 指针> %p, 整数64 %idx
  %gep = getelementptr nusw nuw i8, <2 x ptr> %p, i64 %idx
  ret <2 x ptr> %gep
}

define ptr @const_gep_nuw() {
; CHECK: 返回 指针 获取元素指针 nuw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr nuw (i8, ptr @addr, i64 100)
}

define ptr @const_gep_inbounds_nuw() {
; CHECK: 返回 指针 获取元素指针 inbounds nuw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr inbounds nuw (i8, ptr @addr, i64 100)
}

define ptr @const_gep_nusw() {
; CHECK: 返回 指针 获取元素指针 nusw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr nusw (i8, ptr @addr, i64 100)
}

; inbounds implies nusw, so the flag is not printed back.
define ptr @const_gep_inbounds_nusw() {
; CHECK: 返回 指针 获取元素指针 inbounds (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr inbounds nusw (i8, ptr @addr, i64 100)
}

define ptr @const_gep_nusw_nuw() {
; CHECK: 返回 指针 获取元素指针 nusw nuw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr nusw nuw (i8, ptr @addr, i64 100)
}

define ptr @const_gep_inbounds_nusw_nuw() {
; CHECK: 返回 指针 获取元素指针 inbounds nuw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr inbounds nusw nuw (i8, ptr @addr, i64 100)
}

define ptr @const_gep_nuw_nusw_inbounds() {
; CHECK: 返回 指针 获取元素指针 inbounds nuw (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr nuw nusw inbounds (i8, ptr @addr, i64 100)
}

define ptr @const_gep_nuw_inrange() {
; CHECK: 返回 指针 获取元素指针 nuw inrange(-8, 16) (整数8, 指针 @addr, 整数64 100)
  ret ptr getelementptr nuw inrange(-8, 16) (i8, ptr @addr, i64 100)
}

define ptr addrspace(1) @const_gep_nusw_nuw_as1() {
; CHECK: 返回 指针 addrspace(1) 获取元素指针 nusw nuw (整数8, 指针 addrspace(1) @addr_as1, 整数64 100)
  ret ptr addrspace(1) getelementptr nusw nuw (i8, ptr addrspace(1) @addr_as1, i64 100)
}
