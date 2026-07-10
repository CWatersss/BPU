# BPU 接口文档

## 版本范围
- 顶层模块：`BPU`
- 快速预测路径：`Gshare + BTB + RAS`
- 二级预测：`TAGE`
- 当前 BTB/RAS 关系：BTB 存储目标和类型位 `cond/call/ret/jump`，RAS 只维护返回地址栈

新增接口(BPU)：
    input flush,  // flush 时清空 S1 事件，避免 stale correction
    output correct_valid,      // L2 覆盖 L1（针对落后 1 拍的取指）
    output correct_taken,      // TAGE 方向
    output [31:0] correct_npc, // 纠正 NPC = btb_target 或 branch_pc+4
    output [31:0] correct_pc,  // 被纠正分支 PC（供 IFU FIFO 匹配）
    //TAGE 预测 metadata（输出，C2 有效，后续锁进流水携带）
    output tage_meta_valid,
    output [`TAO_TAGE_META_W-1:0] tage_meta,
    //TAGE 提交 metadata（输入，用于更新）
    input tage_upd_valid,      // = actural_valid & actural_cond
    input tage_upd_taken,      // = actural_taken
    input [`TAO_TAGE_META_W-1:0] tage_upd_meta


BPU该怎么和IFU的FIFO交互未确定；
BPU需要接BP_flush(BPU流水架构，里面的寄存器需要清空)

BPU中的`tage_meta`和`tage_meta_valid`(由于TAGE而新增的)需要随流水线进入EXU
EXU中的TAGE metadata 需要传回 IFU/BPU 更新侧

tao_define.v中也需要添加一部分

## BPU 顶层端口

### 时钟和复位
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `clock` | input | 1 | 时钟，上升沿有效 |
| `reset` | input | 1 | 复位，高有效 |
| `flush` | input | 1 | 前端/流水线 flush。打开 TAGE 时用于清空 BPU/TAGE 的 S1 事件，避免 stale correction |

### 预测请求侧
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `pc` | input | 32 | 当前 IFU 请求预测的 PC |
| `pred_fire` | input | 1 | 本拍预测请求被 IFU 接受。当前接法等于 IFU 的 `require_go` |
| `pred_info` | output | 2 | 调试信息，当前为 `{pred_valid, direct_pred_taken}` |
| `pred_taken` | output | 1 | 最终预测是否跳转 |
| `pred_npc` | output | 32 | 最终预测下一 PC |
| `pred_index` | output | `` `TAO_GSHARE_LENGTH `` | Gshare 本次预测使用的 PHT index，后续提交更新时回传 |
| `ras_pred_pop` | output | 1 | 本次预测是否对 RAS 做了 speculative pop |
| `ras_checkpoint` | output | 4 | 预测前 RAS 栈计数 checkpoint，用于误预测恢复 |

预测组合逻辑：

```verilog
pred_cond_taken = pred_cond & direct_pred_taken;
pred_call_taken = pred_call;
pred_ret_taken  = pred_ret;
pred_jump_taken = pred_jump;

pred_taken = pred_cond_taken | pred_call_taken | pred_ret_taken | pred_jump_taken;
pred_npc   = (pred_ret_taken & ras_top_valid) ? ras_top_addr :
             pred_taken ? pred_target :
             pc + 4;
```

### 提交更新侧

这些信号来自 EXU 侧已经确定结果的指令。
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `BTB_unvalid` | input | 1 | 非控制流指令被错误预测 taken 时，清除对应 BTB entry |
| `actural_valid` | input | 1 | 当前 EXU 提交侧有控制流更新。当前连接为 `BP_update` |
| `actural_pc` | input | 32 | 实际控制流指令 PC |
| `actural_index` | input | `` `TAO_GSHARE_LENGTH `` | IFU 预测时保存的 Gshare index |
| `actural_taken` | input | 1 | 实际是否跳转。对 jal/jalr/call/ret 恒为 taken |
| `actural_npc` | input | 32 | 实际下一 PC，也作为 BTB 写入目标 |
| `actural_cond` | input | 1 | 指令是否为条件分支 |
| `actural_call` | input | 1 | 指令是否为 RAS call |
| `actural_ret` | input | 1 | 指令是否为 RAS return |
| `ras_recover` | input | 1 | RAS 是否恢复到 checkpoint，当前连接为 `BP_flush` |
| `ras_recover_count` | input | 4 | RAS 恢复用 checkpoint |
| `ras_commit_pred_pop` | input | 1 | 该 ret 预测时是否已经 speculative pop |

更新规则：
- Gshare 只在 `actural_valid & actural_cond` 时更新。
- BTB 在 `actural_valid & actural_taken` 时写入 `{target, cond, call, ret, jump}`。
- RAS 在 `actural_valid & actural_call` 时 push `actural_pc + 4`。
- RAS 在 `actural_valid & actural_ret` 且需要补偿(ras_commit_pred_pop为0)时 pop。
- `BTB_unvalid` 清除对应 BTB valid 位。

## TAGE 条件端口

### L2 correction 输出
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `correct_valid` | output | 1 | TAGE 与 L1 方向不一致，且该 PC 是 BTB 已识别条件分支时的一拍事件 |
| `correct_taken` | output | 1 | TAGE 给出的方向 |
| `correct_npc` | output | 32 | correction 后下一 PC。taken 用 BTB target，not-taken 用 `pc + 4` |
| `correct_pc` | output | 32 | 被 correction 的分支 PC |
`correct_valid` 是事件信号，不是保持电平。

### TAGE metadata 输出
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `tage_meta_valid` | output | 1 | TAGE C2 结果有效的一拍事件 |
| `tage_meta` | output | `` `TAO_TAGE_META_W `` | 本次预测的 metadata bundle，用于提交时训练 TAGE |

`tage_meta_valid` 和 `correct_valid` 不等价。即使没有 correction，也需要把 metadata 写入对应分支槽。

### TAGE 提交训练输入
| 信号 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `tage_upd_valid` | input | 1 | TAGE 训练有效。应为 `BP_update & BP_actural_cond & tage_meta_valid_in_pipeline` |
| `tage_upd_taken` | input | 1 | 条件分支实际方向 |
| `tage_upd_meta` | input | `` `TAO_TAGE_META_W `` | 预测时保存并随流水传回的 metadata |


