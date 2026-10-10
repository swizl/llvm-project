; RUN: llvm-as < %s | llvm-dis | FileCheck %s
; Check support for basic target extension type usage

@global = global target("spirv.DeviceEvent") zeroinitializer

define target("spirv.Sampler") @foo(target("spirv.Sampler") %a) {
  ret target("spirv.Sampler") %a
}

define target("spirv.Event") @func2() {
  %mem = alloca target("spirv.Event")
  %val = load target("spirv.Event"), ptr %mem
  ret target("spirv.Event") poison
}

; CHECK: @global = 全局 target("spirv.DeviceEvent") 零初始化
; CHECK: 定义 target("spirv.Sampler") @foo(target("spirv.Sampler") %a) {
; CHECK:   返回 target("spirv.Sampler") %a
; CHECK: }
; CHECK: 定义 target("spirv.Event") @func2() {
; CHECK:   %mem = 分配 target("spirv.Event")
; CHECK:   %val = 加载 target("spirv.Event"), 指针 %mem
; CHECK:   返回 target("spirv.Event") 毒药值
; CHECK: }
