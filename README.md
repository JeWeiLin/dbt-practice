Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

### Dataset Discription
| **欄位名稱**                  | **說明**                                                                                                                                                          |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **VendorID**              | 計程車電子派遣系統 (TPEP) 提供者代碼：<br>• **1 = Creative Mobile Technologies** <br>• **2 = VeriFone Inc.**                                                                   |
| **tpep_pickup_datetime**  | 上車時間（計費開始時間）。                                                                                                                                                   |
| **tpep_dropoff_datetime** | 下車時間（計費結束時間）。                                                                                                                                                   |
| **Passenger_count**       | 乘客數量，由司機輸入。                                                                                                                                                     |
| **Trip_distance**         | 行程距離（英里）。                                                                                                                                                       |
| **Pickup_longitude**      | 上車地點的經度。                                                                                                                                                        |
| **Pickup_latitude**       | 上車地點的緯度。                                                                                                                                                        |
| **RateCodeID**            | 行程結束時計費代碼：<br>• 1 = 一般費率（Standard rate）<br>• 2 = JFK 機場<br>• 3 = Newark 機場<br>• 4 = Nassau 或 Westchester<br>• 5 = 協議費率（Negotiated fare）<br>• 6 = 共乘（Group ride） |
| **Store_and_fwd_flag**    | 是否為「暫存後上傳」紀錄（無網路連線時暫存）：<br>• **Y = 暫存後上傳**<br>• **N = 立即上傳**                                                                                                    |
| **Dropoff_longitude**     | 下車地點的經度。                                                                                                                                                        |
| **Dropoff_latitude**      | 下車地點的緯度。                                                                                                                                                        |
| **Payment_type**          | 付款方式代碼：<br>• 1 = 信用卡<br>• 2 = 現金<br>• 3 = 無需付款（No charge）<br>• 4 = 糾紛（Dispute）<br>• 5 = 未知（Unknown）<br>• 6 = 作廢行程（Voided trip）                                  |
| **Fare_amount**           | 計程表依時間與距離計算的基本車資。                                                                                                                                               |
| **Extra**                 | 其他附加費用，例如：<br>• **$0.50** 夜間加成 <br>• **$1.00** 尖峰時段加成。                                                                                                          |
| **MTA_tax**               | **$0.50** MTA（大都會運輸局）稅。                                                                                                                                         |
| **Improvement_surcharge** | **$0.30** 改善附加費，自 2015 年起在起錶時計收。                                                                                                                                |
| **Tip_amount**            | 小費金額：僅包含信用卡支付的小費（不含現金）。                                                                                                                                         |
| **Tolls_amount**          | 行程中所有過路費總額。                                                                                                                                                     |
| **Total_amount**          | 乘客支付的總金額（不含現金小費）。                                                                                                                                               |

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
