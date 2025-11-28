## 1. Unity Catalog 
本專案利用 Unity Catalog 建立標準化的資料存取與管理模式：

* 標準化命名空間: 實作 Catalog.Schema.Table 三層結構。

> Catalog: Workspace。

> Schema: 對應 Medallion 架構 (Bronze/Silver/Gold)。

> Table: 使用 Managed Tables 管理實體資料。

Managed Volumes: 使用 Volumes (/Volumes/workspace/raw/...) 統一管理原始 CSV 檔案與 Auto Loader Checkpoints。

## 2. Delta Lake
* 採用 Delta Lake 格式，確保資料管線的強健性與效能：

* ACID 交易 (Reliability): 確保 Auto Loader 寫入與 dbt 讀取時的資料一致性，支援並發操作。

* Schema Evolution: 透過 .option("mergeSchema", "true") 自動適應上游資料欄位新增，防止 Pipeline 中斷。


## 3. Structured Streaming 與 Incremental Data Ingestion
* 底層採用 Spark Structured Streaming 引擎，將資料流視為無界限的資料表 (Unbounded Table)

* 增量處理 (Process New Data Only): 系統僅處理自上次執行後新增的資料，而非每次重跑全量資料。這大幅降低了運算成本並縮短了資料延遲。

* 狀態管理 (Checkpointing): 透過 Checkpoint 機制紀錄 Offset，確保在管線失敗重啟時能從斷點續傳，避免資料遺失或重複。

* Multi-hop Architecture：

> Bronze (Raw): 透過 Auto Loader 原始攝取，保留資料原貌 (As-is)，僅追加 Metadata 。

> Silver (Refined): 進行資料清理、去重 (Deduplication) 與型別轉換。

> Gold (Aggregated): 針對特定商業邏輯進行聚合與 Join，產出直接供 BI 報表或 ML 模型使用的商業級資料。


### Dataset Discription

| **欄位名稱**              | **說明**                                                                                                                                                                                       |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **VendorID**              | 計程車電子派遣系統 (TPEP) 提供者代碼：<br>• **1 = Creative Mobile Technologies** <br>• **2 = VeriFone Inc.**                                                                                   |
| **tpep_pickup_datetime**  | 上車時間（計費開始時間）。                                                                                                                                                                     |
| **tpep_dropoff_datetime** | 下車時間（計費結束時間）。                                                                                                                                                                     |
| **Passenger_count**       | 乘客數量，由司機輸入。                                                                                                                                                                         |
| **Trip_distance**         | 行程距離（英里）。                                                                                                                                                                             |
| **Pickup_longitude**      | 上車地點的經度。                                                                                                                                                                               |
| **Pickup_latitude**       | 上車地點的緯度。                                                                                                                                                                               |
| **RateCodeID**            | 行程結束時計費代碼：<br>• 1 = 一般費率（Standard rate）<br>• 2 = JFK 機場<br>• 3 = Newark 機場<br>• 4 = Nassau 或 Westchester<br>• 5 = 協議費率（Negotiated fare）<br>• 6 = 共乘（Group ride） |
| **Store_and_fwd_flag**    | 是否為「暫存後上傳」紀錄（無網路連線時暫存）：<br>• **Y = 暫存後上傳**<br>• **N = 立即上傳**                                                                                                   |
| **Dropoff_longitude**     | 下車地點的經度。                                                                                                                                                                               |
| **Dropoff_latitude**      | 下車地點的緯度。                                                                                                                                                                               |
| **Payment_type**          | 付款方式代碼：<br>• 1 = 信用卡<br>• 2 = 現金<br>• 3 = 無需付款（No charge）<br>• 4 = 糾紛（Dispute）<br>• 5 = 未知（Unknown）<br>• 6 = 作廢行程（Voided trip）                                 |
| **Fare_amount**           | 計程表依時間與距離計算的基本車資。                                                                                                                                                             |
| **Extra**                 | 其他附加費用，例如：<br>• **$0.50** 夜間加成 <br>• **$1.00** 尖峰時段加成。                                                                                                                    |
| **MTA_tax**               | **$0.50** MTA（大都會運輸局）稅。                                                                                                                                                              |
| **Improvement_surcharge** | **$0.30** 改善附加費，自 2015 年起在起錶時計收。                                                                                                                                               |
| **Tip_amount**            | 小費金額：僅包含信用卡支付的小費（不含現金）。                                                                                                                                                 |
| **Tolls_amount**          | 行程中所有過路費總額。                                                                                                                                                                         |
| **Total_amount**          | 乘客支付的總金額（不含現金小費）。                                                                                                                                                             |


### Databricks Data Platform Architecture
- **Platform**: Databricks Data Intelligence Platform
- **Governance**: Unity Catalog (Catalog, Schemas, Volumes)
- **Ingestion**: Spark Structured Streaming, Databricks Auto Loader
- **Transformation**: dbt (data build tool), SQL 
- **Storage Format**: Delta Lake
- **Orchestration**: Databricks Workflows




