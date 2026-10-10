; RUN: llvm-as < %s | llvm-dis | FileCheck %s

; CHECK: 公共 全局 [32 个 b8] 零初始化
; CHECK: 常量 [1 个 b8] 零初始化
; CHECK: 常量 [15 个 b8] 字"Hello, World!\0A\00"
; CHECK: 常量 [15 个 b8] 字"Hello, World!\0A\00"
@a = common global [32 x b8] zeroinitializer, align 1
@b = constant [1 x b8] zeroinitializer
@c = constant [15 x b8] [b8 72, b8 101, b8 108, b8 108, b8 111, b8 44, b8 32,  b8 87, b8 111, b8 114, b8 108, b8 100, b8 33,  b8 10, b8 0]
@d = constant [15 x b8] c"Hello, World!\0A\00"

define void @bytes(b1 %a, b3 %b, b5 %c, b8 %d, b16 %e, b32 %f, b64 %g, b128 %h, <8 x b5> %i, <2 x b64> %j) {
; CHECK-LABEL: 定义 空类型 @bytes(
; CHECK-SAME: b1 [[A:%.*]], b3 [[B:%.*]], b5 [[C:%.*]], b8 [[D:%.*]], b16 [[E:%.*]], b32 [[F:%.*]], b64 [[G:%.*]], b128 [[H:%.*]], <8 个 b5> [[I:%.*]], <2 个 b64> [[J:%.*]]) {
; CHECK-NEXT:    返回 空类型
;
  ret void
}

define void @byte_alloca() {
; CHECK-LABEL: 定义 空类型 @byte_alloca() {
; CHECK-NEXT:    [[B1:%.*]] = 分配 b8, 对齐 1
; CHECK-NEXT:    [[B8:%.*]] = 分配 b64, 对齐 8
; CHECK-NEXT:    [[V:%.*]] = 分配 <4 个 b64>, 对齐 32
; CHECK-NEXT:    [[A:%.*]] = 分配 [4 个 b64], 对齐 8
; CHECK-NEXT:    返回 空类型
;
  %b1 = alloca b8
  %b8 = alloca b64
  %v  = alloca <4 x b64>
  %a  = alloca [4 x b64]
  ret void
}

define void @byte_load_store(ptr %ptr) {
; CHECK-LABEL: 定义 空类型 @byte_load_store(
; CHECK-SAME: 指针 [[PTR:%.*]]) {
; CHECK-NEXT:    [[B:%.*]] = 加载 b8, 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    存储 b8 [[B]], 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    存储 b8 0, 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    [[V:%.*]] = 加载 <4 个 b64>, 指针 [[PTR]], 对齐 32
; CHECK-NEXT:    存储 <4 个 b64> [[V]], 指针 [[PTR]], 对齐 32
; CHECK-NEXT:    存储 <4 个 b64> <b64 0, b64 1, b64 2, b64 3>, 指针 [[PTR]], 对齐 32
; CHECK-NEXT:    [[A:%.*]] = 加载 [4 个 b8], 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    存储 [4 个 b8] [[A]], 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    存储 [4 个 b8] 字"\00\01\02\03", 指针 [[PTR]], 对齐 1
; CHECK-NEXT:    返回 空类型
;
  %b = load b8, ptr %ptr
  store b8 %b, ptr %ptr
  store b8 0, ptr %ptr
  %v = load <4 x b64>, ptr %ptr
  store <4 x b64> %v, ptr %ptr
  store <4 x b64> <b64 0, b64 1, b64 2, b64 3>, ptr %ptr
  %a = load [4 x b8], ptr %ptr
  store [4 x b8] %a, ptr %ptr
  store [4 x b8] [b8 0, b8 1, b8 2, b8 3], ptr %ptr
  ret void
}

define void @bitcasts(i64 %i, b64 %b, ptr %p) {
; CHECK-LABEL: 定义 空类型 @bitcasts(
; CHECK-SAME: 整数64 [[I:%.*]], b64 [[B:%.*]], 指针 [[P:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = 位转换 指针 [[P]] 到 b64
; CHECK-NEXT:    [[TMP2:%.*]] = 位转换 整数64 [[I]] 到 b64
; CHECK-NEXT:    [[TMP3:%.*]] = 位转换 b64 [[B]] 到 <8 个 b8>
; CHECK-NEXT:    [[TMP4:%.*]] = 位转换 b64 [[B]] 到 整数64
; CHECK-NEXT:    [[TMP5:%.*]] = 位转换 b64 [[B]] 到 指针
; CHECK-NEXT:    [[TMP6:%.*]] = 位转换 <8 个 b8> [[TMP3]] 到 <2 个 b32>
; CHECK-NEXT:    [[TMP7:%.*]] = 位转换 <2 个 b32> [[TMP6]] 到 b64
; CHECK-NEXT:    [[TMP8:%.*]] = 位转换 <2 个 b32> splat (b32 1) 到 b64
; CHECK-NEXT:    [[TMP9:%.*]] = 位转换 <8 个 b8> [[TMP3]] 到 <4 个 整数16>
; CHECK-NEXT:    [[TMP10:%.*]] = 位转换 <2 个 b32> [[TMP6]] 到 指针
; CHECK-NEXT:    返回 空类型
;
  %1 = bitcast ptr %p to b64
  %2 = bitcast i64 %i to b64
  %3 = bitcast b64 %b to <8 x b8>
  %4 = bitcast b64 %b to i64
  %5 = bitcast b64 %b to ptr
  %6 = bitcast <8 x b8> %3 to <2 x b32>
  %7 = bitcast <2 x b32> %6 to b64
  %8 = bitcast <2 x b32> <b32 1, b32 1> to b64
  %9 = bitcast <8 x b8> %3 to <4 x i16>
  %10 = bitcast <2 x b32> %6 to ptr
  ret void
}

define void @freeze(b3 %t, b64 %b, <4 x b64> %v) {
; CHECK-LABEL: 定义 空类型 @freeze(
; CHECK-SAME: b3 [[T:%.*]], b64 [[B:%.*]], <4 个 b64> [[V:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = 冻结 b3 [[T]]
; CHECK-NEXT:    [[TMP2:%.*]] = 冻结 b64 [[B]]
; CHECK-NEXT:    [[TMP3:%.*]] = 冻结 <4 个 b64> [[V]]
; CHECK-NEXT:    返回 空类型
;
  %1 = freeze b3 %t
  %2 = freeze b64 %b
  %3 = freeze <4 x b64> %v
  ret void
}
