`define TAO_BP_TWO_LEVEL 1
    //TAGE（4 表, history_len {0,5,12,25}）
`define TAO_TAGE_NUM_TABLES  4
`define TAO_TAGE_GHR_LEN     25          // 25-bit 平坦 GHR，所有 fold 组合切片
`define TAO_TAGE_T0_ENTRIES  512
`define TAO_TAGE_T0_IDX      9           // log2(512)
`define TAO_TAGE_TAG_ENTRIES 256
`define TAO_TAGE_TAG_IDX     8           // log2(256)
`define TAO_TAGE_TAG_W       9
`define TAO_TAGE_CTR_W       3           // taken = counter[2]（>=4）
`define TAO_TAGE_USEFUL_W    2
`define TAO_TAGE_RESET_CNT_W 18          // 2^18 = 262144
`define TAO_TAGE_RESET_IVAL  262144      // useful 周期清零间隔（256K）
`define TAO_TAGE_META_W      63          // 随流水携带的 metadata bundle 位宽
