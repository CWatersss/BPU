##coremark
[perf]  cycles=451416439 inst=318235148 time=303.662 s
[CPI] 1.42
[ifu]
    IFU读申请次数               : 331832074
    IFU取到                     : 331832074
    IFU冲刷                     : 4631310
    IFU等待                     : 112461849
    IFU延误                     : 7217052
[idu]
    iduRAW                      : 214563326
    idu延误                     : 54942994
[exu]
    exu延误                     : 31543473
    乘法运算inst                : 9396098
    除法运算inst                : 32
    乘法运算cycle               : 28188290
    除法运算cycle               : 1052
[lsu]
    取到数据                    : 318235150
    LSU等数据                   : 136485583
    lsu延误                     : 63782747
    LSU读次数                   : 56951771
    LSU写次数                   : 15751065
    LSU读周期                   : 117589997
    LSU写周期                   : 18895586
[dcache]
    dcache读命中                : 56648816
    dcache读缺失                : 302951
    dcache写命中                : 15582894
    dcache写缺失                : 168171
[type_inst]
    普通计算类                  : 171982319
    乘除法                      : 9396130
    读取                        : 59081784
    存                          : 15972460
    CSR                         : 0
    跳转jal                     : 4459880
    跳转jalr                    : 2148232
    分支                        : 58668434
    other                       : 672156
[type_cycle]
    计算类                      : 246030169
    读取                        : 79186305
    存                          : 20521442
    CSR                         : 0
    跳转                        : 104884484
    other                       : 766958
[BP]
    total                       : 4631310
    branch_total                : 65035571
    wrong_total                 : 4778814
    wrong_type_jal              : 730876
    wrong_type_jalr             : 179409
    wrong_type_branch           : 3868529
    wrong_dir                   : 4772778
    wrong_dir_1                 : 992689
    wrong_dir_0                 : 3780089
    wrong_dir_0_dir             : 1165489
    wrong_dir_0_target          : 1342396
    wrong_dir_0_dir_and_target  : 1272204
    wrong_target                : 0
    wrong_dir_target            : 0
    wrong_branch                : 4778814
    wrong_not_branch            : 0
    return总数                  : 2546126
    call总数                    : 3057614
    RAS弹栈次数                 : 2082038
    RAS目标错误                 : 3019
    RAS恢复次数                 : 4631310
[derived]
    总访存指令数           : 72702836.000000
    总访存周期             : 136485583.000000
    平均访存延迟(周期/次)  : 1.877308
    I-Cache miss率         : 0.000000
    I-Cache miss周期占比   : 0.000000
    分支预测总错误率       : 1.031849
    方向预测错误率         : 0.073387
    目标预测错误率         : 0.000000
    乘法平均周期           : 3.000000
    除法平均周期           : 32.875000

##jyd_inst
[perf]  cycles=36090373 inst=30758616 time=25.381 s
[CPI] 1.17
[ifu]
    IFU读申请次数               : 33084195
    IFU取到                     : 33084195
    IFU冲刷                     : 864008
    IFU等待                     : 1247435
    IFU延误                     : 1718746
[idu]
    iduRAW                      : 11290137
    idu延误                     : 3659238
[exu]
    exu延误                     : 155
    乘法运算inst                : 0
    除法运算inst                : 0
    乘法运算cycle               : 0
    除法运算cycle               : 0
[lsu]
    取到数据                    : 30758616
    LSU等数据                   : 1800773
    lsu延误                     : 900435
    LSU读次数                   : 700180
    LSU写次数                   : 200158
    LSU读周期                   : 1600542
    LSU写周期                   : 200231
[dcache]
    dcache读命中                : 700150
    dcache读缺失                : 28
    dcache写命中                : 200111
    dcache写缺失                : 24
[type_inst]
    普通计算类                  : 17373706
    乘除法                      : 0
    读取                        : 700253
    存                          : 200160
    CSR                         : 0
    跳转jal                     : 400125
    跳转jalr                    : 425098
    分支                        : 12295200
    other                       : 188
[type_cycle]
    计算类                      : 20559774
    读取                        : 700269
    存                          : 200235
    CSR                         : 0
    跳转                        : 14629862
    other                       : 216
[BP]
    total                       : 864008
    branch_total                : 12855122
    wrong_total                 : 898328
    wrong_type_jal              : 117
    wrong_type_jalr             : 63
    wrong_type_branch           : 898148
    wrong_dir                   : 898324
    wrong_dir_1                 : 639566
    wrong_dir_0                 : 258758
    wrong_dir_0_dir             : 258564
    wrong_dir_0_target          : 16
    wrong_dir_0_dir_and_target  : 178
    wrong_target                : 0
    wrong_dir_target            : 0
    wrong_branch                : 898328
    wrong_not_branch            : 0
    return总数                  : 500188
    call总数                    : 400249
    RAS弹栈次数                 : 499307
    RAS目标错误                 : 4
    RAS恢复次数                 : 864008
[derived]
    总访存指令数           : 900338.000000
    总访存周期             : 1800773.000000
    平均访存延迟(周期/次)  : 2.000108
    I-Cache miss率         : 0.000000
    I-Cache miss周期占比   : 0.000000
    分支预测总错误率       : 1.039722
    方向预测错误率         : 0.069881
    目标预测错误率         : 0.000000
    乘法平均周期           : 0.000000
    除法平均周期           : 0.000000

##jyd_src0
[perf]  cycles=2275540381 inst=1417754160 time=2736.563 s
[CPI] 1.61
[ifu]
    IFU读申请次数               : 1571733767
    IFU取到                     : 1571733767
    IFU冲刷                     : 57168458
    IFU等待                     : 599100869
    IFU延误                     : 102719987
[idu]
    iduRAW                      : 1423831253
    idu延误                     : 683485050
[exu]
    exu延误                     : 15029729
    乘法运算inst                : 0
    除法运算inst                : 0
    乘法运算cycle               : 0
    除法运算cycle               : 0
[lsu]
    取到数据                    : 1417754160
    LSU等数据                   : 687431451
    lsu延误                     : 391912047
    LSU读次数                   : 254506877
    LSU写次数                   : 41012527
    LSU读周期                   : 645831738
    LSU写周期                   : 41599713
[dcache]
    dcache读命中                : 230452443
    dcache读缺失                : 24054432
    dcache写命中                : 40526616
    dcache写缺失                : 485888
[type_inst]
    普通计算类                  : 883120213
    乘除法                      : 0
    读取                        : 254846259
    存                          : 41034439
    CSR                         : 0
    跳转jal                     : 16239822
    跳转jalr                    : 24761140
    分支                        : 223965098
    other                       : 15041628
[type_cycle]
    计算类                      : 1536312421
    读取                        : 255355283
    存                          : 41504632
    CSR                         : 0
    跳转                        : 427326224
    other                       : 15041757
[BP]
    total                       : 57168458
    branch_total                : 255926138
    wrong_total                 : 57252991
    wrong_type_jal              : 7172407
    wrong_type_jalr             : 37893
    wrong_type_branch           : 50042691
    wrong_dir                   : 57235233
    wrong_dir_1                 : 25957808
    wrong_dir_0                 : 31277425
    wrong_dir_0_dir             : 16888023
    wrong_dir_0_target          : 13327564
    wrong_dir_0_dir_and_target  : 1061838
    wrong_target                : 0
    wrong_dir_target            : 0
    wrong_branch                : 57252991
    wrong_not_branch            : 0
    return总数                  : 51007801
    call总数                    : 16498056
    RAS弹栈次数                 : 47791418
    RAS目标错误                 : 17758
    RAS恢复次数                 : 57168458
[derived]
    总访存指令数           : 295519404.000000
    总访存周期             : 687431451.000000
    平均访存延迟(周期/次)  : 2.326180
    I-Cache miss率         : 0.000000
    I-Cache miss周期占比   : 0.000000
    分支预测总错误率       : 1.001479
    方向预测错误率         : 0.223640
    目标预测错误率         : 0.000000
    乘法平均周期           : 0.000000
    除法平均周期           : 0.000000
make[1]: 离开目录“/home/watersss/JYD-RAS-V2/JYD-contest/npc”

##jyd_src1
[perf]  cycles=2477887190 inst=1304108429 time=2791.581 s
[CPI] 1.90
[ifu]
    IFU读申请次数               : 1355663508
    IFU取到                     : 1355663508
    IFU冲刷                     : 19376325
    IFU等待                     : 1080212737
    IFU延误                     : 41874258
[idu]
    iduRAW                      : 1740373347
    idu延误                     : 781887953
[exu]
    exu延误                     : 28451141
    乘法运算inst                : 0
    除法运算inst                : 0
    乘法运算cycle               : 0
    除法运算cycle               : 0
[lsu]
    取到数据                    : 1304108429
    LSU等数据                   : 1267272303
    lsu延误                     : 732134237
    LSU读次数                   : 466441689
    LSU写次数                   : 68696377
    LSU读周期                   : 1178035263
    LSU写周期                   : 89237040
[dcache]
    dcache读命中                : 420380100
    dcache读缺失                : 46061587
    dcache写命中                : 67318403
    dcache写缺失                : 1377951
[type_inst]
    普通计算类                  : 530587627
    乘除法                      : 0
    读取                        : 467486184
    存                          : 68696585
    CSR                         : 0
    跳转jal                     : 14000710
    跳转jalr                    : 12170613
    分支                        : 223474892
    other                       : 1415321
[type_cycle]
    计算类                      : 1344229381
    读取                        : 472681401
    存                          : 77197606
    CSR                         : 0
    跳转                        : 582363416
    other                       : 1415355
[BP]
    total                       : 19376325
    branch_total                : 246687132
    wrong_total                 : 20238648
    wrong_type_jal              : 1650205
    wrong_type_jalr             : 1195092
    wrong_type_branch           : 17393351
    wrong_dir                   : 20078638
    wrong_dir_1                 : 8880647
    wrong_dir_0                 : 11197991
    wrong_dir_0_dir             : 7657592
    wrong_dir_0_target          : 1460964
    wrong_dir_0_dir_and_target  : 2079435
    wrong_target                : 0
    wrong_dir_target            : 0
    wrong_branch                : 20238648
    wrong_not_branch            : 0
    return总数                  : 14632119
    call总数                    : 13910310
    RAS弹栈次数                 : 12268790
    RAS目标错误                 : 160009
    RAS恢复次数                 : 19376325
[derived]
    总访存指令数           : 535138066.000000
    总访存周期             : 1267272303.000000
    平均访存延迟(周期/次)  : 2.368122
    I-Cache miss率         : 0.000000
    I-Cache miss周期占比   : 0.000000
    分支预测总错误率       : 1.044504
    方向预测错误率         : 0.081393
    目标预测错误率         : 0.000000
    乘法平均周期           : 0.000000
    除法平均周期           : 0.000000

##jyd_src2
[perf]  cycles=2758548941 inst=1849099373 time=3291.044 s
[CPI] 1.49
[ifu]
    IFU读申请次数               : 2097218152
    IFU取到                     : 2097218152
    IFU冲刷                     : 93792954
    IFU等待                     : 500915111
    IFU延误                     : 159036816
[idu]
    iduRAW                      : 1335805489
    idu延误                     : 648387574
[exu]
    exu延误                     : 42155542
    乘法运算inst                : 0
    除法运算inst                : 0
    乘法运算cycle               : 0
    除法运算cycle               : 0
[lsu]
    取到数据                    : 1849099373
    LSU等数据                   : 661389821
    lsu延误                     : 353509763
    LSU读次数                   : 214460002
    LSU写次数                   : 93420056
    LSU读周期                   : 560486826
    LSU写周期                   : 100902995
[dcache]
    dcache读命中                : 198971702
    dcache读缺失                : 15488298
    dcache写命中                : 81920986
    dcache写缺失                : 11499047
[type_inst]
    普通计算类                  : 1025191240
    乘除法                      : 0
    读取                        : 228655825
    存                          : 93424069
    CSR                         : 0
    跳转jal                     : 30800353
    跳转jalr                    : 22391419
    分支                        : 485643891
    other                       : 24947679
[type_cycle]
    计算类                      : 1572466390
    读取                        : 272132693
    存                          : 165483866
    CSR                         : 0
    跳转                        : 723512245
    other                       : 24953719
[BP]
    total                       : 93792954
    branch_total                : 529441588
    wrong_total                 : 95195409
    wrong_type_jal              : 19357
    wrong_type_jalr             : 7586
    wrong_type_branch           : 95168466
    wrong_dir                   : 95188898
    wrong_dir_1                 : 55846196
    wrong_dir_0                 : 39342702
    wrong_dir_0_dir             : 36503029
    wrong_dir_0_target          : 2731337
    wrong_dir_0_dir_and_target  : 108336
    wrong_target                : 0
    wrong_dir_target            : 0
    wrong_branch                : 95195409
    wrong_not_branch            : 0
    return总数                  : 34087336
    call总数                    : 24507180
    RAS弹栈次数                 : 27103775
    RAS目标错误                 : 4012
    RAS恢复次数                 : 93792954
[derived]
    总访存指令数           : 307880058.000000
    总访存周期             : 661389821.000000
    平均访存延迟(周期/次)  : 2.148206
    I-Cache miss率         : 0.000000
    I-Cache miss周期占比   : 0.000000
    分支预测总错误率       : 1.014953
    方向预测错误率         : 0.179791
    目标预测错误率         : 0.000000
    乘法平均周期           : 0.000000
    除法平均周期           : 0.000000
