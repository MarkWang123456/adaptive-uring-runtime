# Research Questions

更新日期：2026-07-21  
文件狀態：Concept Draft v0.3  
目前階段：平台環境基線與功能 smoke test 已完成；下一步為 Default／SQPOLL 靜態 Baseline。

---

## 1. 文件目的

本文件目前只固定研究方向、暫定 Research Questions、核心範圍與階段性決策條件。

具體 workload matrix、監控欄位、Utility、Controller 門檻、ML 標籤、eBPF 特徵與 Default／SQPOLL 切換實作，將依文獻調查及靜態 Baseline 結果，在後續專門文件中逐步定義。

目前內容是研究發想與工作假設，不代表研究缺口、方法及預期結果已正式確認。

---

## 2. 研究定位

本研究以 Raspberry Pi 4 ARM64 為平台，使用 USB 3.0／UASP／NVMe 儲存路徑，分析 Linux io_uring Default 與 SQPOLL 在不同 workload 與 thermal state 下的效能與資源取捨。

若兩種模式之間存在可重現且具有實質意義的差異，本研究將進一步建立一套通用 userspace Storage I/O Runtime，根據 workload 與系統狀態選擇較適合的模式。

本研究不預設 SQPOLL、動態切換、Simple ML 或 eBPF 一定能帶來正面效益。負面結果或簡單方法已足夠，均可形成有效研究結論。

---

## 3. 核心研究場景

### 平台

- Raspberry Pi 4 ARM64
- Linux
- USB 3.0／UASP
- USB-to-NVMe bridge
- NVMe SSD
- 資源與散熱受限環境

### 主要比較策略

- io_uring Default
- io_uring SQPOLL
- Fixed Default
- Fixed SQPOLL
- Rule-based dynamic selection

### 後續比較項目

- Simple ML Controller
- eBPF 額外特徵
- synthetic workload
- 至少一個真實應用 Adapter

---

## 4. 暫定 Research Questions

### RQ1：Default 與 SQPOLL 的相對效益是否會隨 workload 與 thermal state 改變？

在 Raspberry Pi 4 的 USB 3.0／UASP／NVMe 路徑上，Default 與 SQPOLL 在不同 block size、queue depth、存取型態、request rate、CPU 使用與 thermal state 下，是否呈現可重現且具有實質意義的效能與資源差異？

本研究不預設一定存在模式交叉。可能結果包括：

- SQPOLL 只在少數 workload 有利；
- Default 在大多數條件下較合適；
- 兩者差異小於實驗變異；
- thermal state 不會改變模式相對優劣；
- USB／UASP 或裝置端瓶頸掩蓋 submission-side 差異。

### RQ2：動態選擇是否比最佳固定策略更有價值？

若 RQ1 顯示 Default 與 SQPOLL 之間存在可利用的差異，根據 workload 與 thermal state 動態選擇模式，是否能在計入監控、決策與切換成本後，優於最佳固定策略？

動態策略的價值不只限於提高 throughput 或 IOPS，也可能表現在：

- 降低 p95／p99 latency；
- 降低 CPU 使用；
- 降低溫度或 throttling；
- 減少不同 workload phase 下的最差情況。

核心 Controller 優先使用可解釋的 Rule-based 方法。

### RQ3：Runtime 是否能安全切換並跨應用重複使用？

所建立的 userspace Storage I/O Runtime，是否能：

- 提供通用的非同步讀寫與完成處理介面；
- 支援 Default 與 SQPOLL backend；
- 在切換過程中維持 request、ordering、fsync、error 與 fallback semantics；
- 被 synthetic workload generator 使用；
- 透過 Adapter 被至少一個真實應用使用；
- 避免在 Runtime core 中加入特定應用邏輯？

---

## 5. 候選子問題

以下先保留為候選子問題，不在現階段視為必須成立的核心貢獻。

### 候選子問題 A：Simple ML 是否比 Rule-based 更有價值？

若 RQ2 顯示動態策略確實具有改善空間，Simple ML（優先使用 Decision Tree）是否能比 Rule-based 更接近各 workload 階段的適合模式？

評估重點是最終 system utility 與額外成本，而不是只有分類準確率。

若 ML 未優於 Rule-based，則「簡單規則已足夠」可作為研究結論。

### 候選子問題 B：eBPF 特徵是否提供額外決策價值？

在 application、proc 與 sysfs 特徵之外，eBPF 提供的 kernel telemetry 是否能改善模式選擇，且其效益足以抵銷觀測 overhead、event loss 與實作複雜度？

若沒有淨效益，eBPF 僅保留為離線 profiling 或原因分析工具。

---

## 6. 研究方法概略

研究預計依序進行：

1. 建立可重現的 Raspberry Pi 實驗環境與監控能力。
2. 完成 Default／SQPOLL 靜態 Pilot Baseline。
3. 建立正式 workload characterization。
4. 判斷是否存在值得利用的模式差異。
5. 建立 Runtime core 與 Default／SQPOLL backend。
6. 驗證切換 correctness 與切換成本。
7. 實作 Rule-based Controller。
8. 視 RQ2 結果決定是否進行 Simple ML。
9. 視基礎特徵不足與時程決定是否進行 eBPF 消融。
10. 以 synthetic workload 與至少一個真實應用驗證 Runtime。
11. 補充 NVMe 同時作為系統碟的部署驗證。

---

## 7. 目前優先工作

目前只優先回答 RQ1 的前半部：

> Default 與 SQPOLL 在少量代表 workload 下，是否能穩定執行、被公平量測，並呈現大於實驗變異的差異？

下一個正式產出為：

- Default／SQPOLL Pilot Baseline Protocol
- 最小監控工具
- 統一實驗輸出格式
- 小規模 Pilot 結果

現階段不需要先決定：

- 最終 Utility 公式與權重
- ML Label 與 Tie threshold
- eBPF tracepoint
- 雙 Ring或 Ring rebuild
- Rule-based threshold
- decision window
- minimum dwell time
- 完整 workload matrix

---

## 8. 階段性決策條件

### Gate 1：靜態 Baseline

若 Default 與 SQPOLL 存在可重現且具有實質意義的差異：

- 繼續建立 Runtime 與動態切換。

若差異不足：

- 不強行建立複雜 Controller；
- 評估固定策略建議；
- 必要時考慮 queue depth、batch size、submission frequency 或 wait strategy 等其他 Runtime action。

### Gate 2：Rule-based Controller

若 Rule-based 在計入完整成本後優於最佳固定策略：

- 建立 ML dataset，評估 Simple ML。

若沒有淨效益：

- 停止增加 Controller 複雜度；
- 將切換成本與固定策略邊界作為研究結果。

### Gate 3：Simple ML 與 eBPF

若 Simple ML 或 eBPF 沒有足以抵銷成本的額外價值：

- 不強行保留在線上 Runtime；
- 將負面結果納入論文分析。

---

## 9. 核心與延伸範圍

### 核心畢業主線

- Default／SQPOLL Baseline
- 通用 Runtime
- 安全模式切換
- Rule-based Controller
- 完整實驗與論文
- synthetic workload 加一個真實應用

### 後續比較

- Simple ML
- eBPF 特徵消融
- NVMe 系統碟部署驗證

### 結果驅動的延伸

- Hybrid IOPOLL／Hybrid Poll
- 最小 Kernel hook
- 第二顆 SSD
- 第二種 USB bridge
- 第二個真實應用
- 跨平台驗證

延伸項目不得阻塞核心論文完成。

---

## 10. 有效負面結果

以下結果均可形成有效研究結論：

- SQPOLL 在 USB／UASP 路徑上沒有顯著收益。
- SQPOLL 的 CPU 或 thermal cost 高於效能收益。
- Default 在大多數條件下已接近最佳。
- 動態切換無法回收監控與切換成本。
- Rule-based 已足夠，ML 無額外價值。
- eBPF 特徵無額外決策價值。
- thermal state 不影響模式選擇。
- 隔離環境中的規則無法直接推廣至 NVMe 系統碟部署。
- Runtime 只能支援有限的 I/O semantics。

---

## 11. 研究適用範圍

本研究的主要結論首先適用於受測的 Raspberry Pi 4、Kernel、liburing、USB-to-NVMe bridge、NVMe SSD、filesystem、I/O scheduler、電源與散熱配置。

除非進行額外驗證，不將結果直接推廣至所有 ARM edge devices、所有 USB／UASP enclosure、原生 PCIe NVMe、Raspberry Pi 5、x86 server 或所有 Linux Kernel 版本。

---

## 12. 待文獻與實驗確認

- ARM edge platform 上的 Linux Storage I/O 研究缺口
- Raspberry Pi 應用 workload 與本機 Storage I/O 的關係
- Default／SQPOLL 的正式公平比較條件
- 正式 workload matrix
- CPU governor 與 thermal 實驗政策
- 具有實質意義的效果門檻
- Runtime 切換實作
- Rule-based 特徵與門檻
- Simple ML 是否值得
- eBPF 是否值得
- 真實應用選擇

---

## 13. 文件維護原則

本文件目前只作為概略方向，不承載所有實驗細節。

後續細節應分流至：

- Baseline 實驗設計
- Runtime 設計
- Rule-based Controller
- ML Dataset
- eBPF Profiling
- 實驗分析
- 論文寫作

若後續文獻、Baseline 或教授意見與本文件衝突：

1. 以較新的正式決策為準；
2. 明確記錄衝突與修改原因；
3. 不得默默改變研究方向。