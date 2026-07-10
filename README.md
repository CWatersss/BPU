# RISC-V 分支预测单元

这是一个面向 32 位 RISC-V 顺序流水线 CPU 的分支预测单元。设计目标是在 IF 阶段提供快速预测路径，并接入 TAGE 作为二级方向预测器，用于修正条件分支预测结果。

## 特性
- 使用 Gshare 预测条件分支方向
- BTB 保存跳转目标和分支类型：`cond`、`call`、`ret`、`jump`
- RAS 用于函数返回地址预测
- 支持 TAGE/Gshare 不一致时的前端重定向修正

## 结构
```text
.
├── BPU.v                         # 顶层
├── BTB.v                         # 分支目标缓冲
├── Gshare.v                      # 快速方向预测器
├── RAS.v                         # 返回地址栈
├── TAGE.v                        # 二级 TAGE 预测器
├── tao_define_ap.v               # 需添加到 tao_defines.v 的定义
├── interface_in_pipeline.md      # 接口说明
└── PERF.md                       # 性能测试结果
```

## 问题
TAGE预测器实现的是简化版本，缺少更好的fold--->index机制，缺少alternate机制（todo）！！导致性能并没有特别优秀
TAGE的时序问题待分析
