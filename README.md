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



## 1. Unity Catalog：統一的資料治理層
Unity Catalog 是 Databricks 的統一治理解決方案，本專案利用它解決了傳統 Hive Metastore 權限分散與檔案管理困難的問題。
三層命名空間 (Three-Level Namespace): 專案中所有的資料存取皆遵循 Catalog.Schema.Table 的標準結構，確保 dbt 與 Auto Loader 能精準定位資料。
* Catalog (workspace): 最上層的容器，隔離環境邊界。
* Schema (bronze, silver, gold): 邏輯分層，對應 Medallion 架構的不同階段。
* Table: 實體資料表 (Managed Tables)。

Managed Volumes: 在 Bronze 層的攝取階段，使用了 Unity Catalog Volumes (/Volumes/workspace/raw/...) 來管理非結構化的 CSV 檔案與 Checkpoint。



## 2. Delta Lake：可靠的儲存格式
資料在進入 Bronze 層後，轉換為 Delta Lake 格式。此 Parquet 檔案，具備 ACID 交易特性的儲存層。在本專案中，Delta Lake 具有以下作用：

* ACID 交易保障 (Reliability): 當 Auto Loader 正在寫入資料 (writeStream) 而 dbt 同時在讀取資料 (dbt run) 時，Delta Lake 確保了讀寫不衝突，讀取者永遠只會讀到已 committed 的完整資料，不會讀到寫到一半的髒資料。

* Schema Evolution (結構演進): 在 Auto Loader 程式碼中設定了 .option("mergeSchema", "true")。
當上游 Uber/Taxi 的 CSV 檔案突然新增欄位時，Delta Lake 允許底層資料表結構自動擴充，而不會導致管線崩潰 (Pipeline Failure)。效能最佳化: dbt 在 Silver/Gold 層進行轉換時，Delta Lake 的 Metadata 統計資訊 (Min/Max values, Z-Ordering) 能大幅加速 SQL查詢與過濾 (WHERE) 的效能。
