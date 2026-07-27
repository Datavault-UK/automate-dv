# Hỗ trợ Microsoft Fabric (`target.type == 'fabric'`)

Tài liệu này ghi lại **cách AutomateDV được mở rộng để hỗ trợ Microsoft Fabric** (adapter `dbt-fabric`),
để lần sau chỉnh sửa không phải dò lại từ đầu.

## 1. Nguyên tắc thiết kế

- **KHÔNG đổi tên `sqlserver__` → `fabric__`.** SQL Server vẫn phải chạy được. Cả hai adapter cùng tồn tại.
- dbt dispatch tự tìm macro theo thứ tự `fabric__<macro>` → `default__<macro>`.
  Nó **không** tự fallback sang `sqlserver__`, nên **mọi** macro có bản `sqlserver__` đều cần một bản `fabric__`.
- Vì Fabric là một biến thể T-SQL rất gần SQL Server, đa số `fabric__` chỉ **ủy quyền (delegate)**
  sang `sqlserver__`. Chỉ override những chỗ Fabric thực sự khác.

Nhờ delegate, khi `fabric__cast_binary` gọi `automate_dv.sqlserver__cast_binary()`, và bên trong đó gọi
`automate_dv.type_binary()`, dbt vẫn dispatch `type_binary` theo `target.type='fabric'` → `fabric__type_binary`.
Do đó chỉ cần override ở tầng thấp nhất, các macro cấp cao tự động dùng đúng.

## 2. Ba khác biệt thật sự của Fabric (các macro OVERRIDE)

| Macro | File | Khác biệt |
|-------|------|-----------|
| `fabric__type_binary` | `macros/supporting/data_types/type_binary.sql` | Fabric không có kiểu `BINARY` cho cột hash → dùng `CHAR(n)` chứa hex. |
| `fabric__binary_ghost` | `macros/supporting/ghost_records/binary_ghost.sql` | Ghost record dùng `REPLICATE('0', n) AS CHAR(n)` thay cho `BINARY`. |
| `fabric__cast_datetime` | `macros/supporting/casting/cast_datetime.sql` | Cần chỉ định precision: `CONVERT(DATETIME2(6), ...)`. Fabric giới hạn `datetime2`/`time` tối đa **6 chữ số** phần thập phân của giây → **bắt buộc** dùng `(6)`, không để mặc định `(7)`. |

### Độ dài CHAR theo thuật toán hash (QUAN TRỌNG)

Hash được lưu dưới dạng chuỗi **hex** (`CONVERT(..., style 2)`), nên độ dài CHAR = **số byte × 2**:

| `hash` var | Số byte | Độ dài CHAR |
|-----------|---------|-------------|
| `md5`  | 16 | `CHAR(32)` |
| `sha1` | 20 | `CHAR(40)` |
| `sha` (SHA-256) | 32 | `CHAR(64)` |

> ⚠️ **Lưu ý bug lịch sử:** phiên bản fork đầu tiên để `CHAR(32)` cho *mọi* thuật toán → **cắt cụt** SHA-256/SHA-1.
> Bản hiện tại đã sửa đúng độ dài. Nếu đổi độ dài ở `fabric__type_binary` thì phải đổi khớp ở `fabric__binary_ghost`.

## 3. TRUNCATE — nay đã được hỗ trợ

> **Cập nhật 2026-06 (theo T-SQL surface area của Fabric DW):** `TRUNCATE TABLE` **đã được hỗ trợ**
> trong Fabric Warehouse. Vì vậy `macros/materialisations/incremental_pit_bridge_replace.sql`
> dùng thẳng `TRUNCATE TABLE` cho cả SQL Server lẫn Fabric — **không** còn workaround `DELETE FROM`.

Lịch sử: bản Fabric đời đầu chưa hỗ trợ `TRUNCATE` nên từng phải thay bằng `DELETE FROM`.
Nếu gặp lỗi TRUNCATE trên workspace Fabric cũ, mới cần cân nhắc quay lại `DELETE FROM`.

## 4. Các macro DELEGATE (chỉ gọi lại `sqlserver__`)

Mỗi macro dưới đây có bản `fabric__` đặt **cùng file** với bản `sqlserver__`, nội dung chỉ là
`{{ automate_dv.sqlserver__<macro>(...) }}`:

- **Bảng** (thư mục mới `macros/tables/fabric/`): `hub`, `link`, `sat`, `eff_sat`, `ma_sat`,
  `nh_link`, `pit`, `bridge`, `ref_table`, `xts`.
- **Hash / casting / kiểu**: `hash`, `cast_binary`, `cast_date`, `type_string`, `type_timestamp`,
  `null_ghost`, `null_expression`, `standard_column_wrapper`, `max_datetime`,
  `hash_alg_md5`, `hash_alg_sha256`, `hash_alg_sha1`.
- **Internal / metadata**: `dateadd`, `concat_ws`, `get_escape_characters`, `null_column_sql`.
- **Period / rank materialization helpers**: `check_num_periods`, `get_period_boundaries`,
  `get_period_filter_sql`, `get_period_of_load`, `replace_placeholder_with_period_filter`,
  `replace_placeholder_with_rank_filter`.

## 5. Các nhánh `target.type` đã mở rộng để bao gồm `'fabric'`

Những chỗ code rẽ nhánh theo adapter đã được thêm `'fabric'` cạnh `'sqlserver'`:

- `macros/materialisations/drop_temporary.sql`
- `macros/materialisations/incremental_bridge_materialization.sql`
- `macros/materialisations/incremental_pit_materialization.sql`
- `macros/materialisations/vault_insert_by_period_materialization.sql`
- `macros/materialisations/vault_insert_by_rank_materialization.sql`
- `macros/tables/snowflake/{bridge,eff_sat,ma_sat,pit}.sql` (đây là các implement dùng chung,
  rẽ nhánh SQL theo adapter — Fabric xử lý giống `sqlserver`/`postgres`).

## 6. Materialization theo adapter

dbt dispatch materialization **theo tên adapter**, không dùng `default` nếu có bản chuyên biệt.
Hai materialization có bản `adapter='sqlserver'` nên đã thêm bản `adapter='fabric'` song song
(hiện đều gọi `currently_disabled_error`, giống SQL Server):

- `macros/materialisations/vault_insert_by_period_materialization.sql`
- `macros/materialisations/vault_insert_by_rank_materialization.sql`

## 7. Checklist khi thêm/sửa macro trong tương lai

1. Thêm một `sqlserver__<macro>` mới? → **thêm luôn `fabric__<macro>`** (delegate hoặc override).
2. Thêm nhánh `target.type == 'sqlserver'` mới? → cân nhắc thêm `'fabric'`.
3. Đổi độ dài/kiểu hash ở `fabric__type_binary`? → đổi khớp ở `fabric__binary_ghost`.
4. Thêm materialization `adapter='sqlserver'`? → thêm bản `adapter='fabric'`.
5. Kiểm tra parity nhanh:
   ```bash
   diff <(grep -rhoE 'macro sqlserver__[a-zA-Z0-9_]+' macros/ | sed 's/.*sqlserver__//' | sort -u) \
        <(grep -rhoE 'macro fabric__[a-zA-Z0-9_]+'    macros/ | sed 's/.*fabric__//'    | sort -u)
   ```
   Mọi macro `sqlserver__` phải có `fabric__` tương ứng.

## 8. Cấu hình `profiles.yml` phía người dùng

```yaml
my_project:
  target: fabric
  outputs:
    fabric:
      type: fabric
      driver: 'ODBC Driver 18 for SQL Server'
      server: <workspace>.datawarehouse.fabric.microsoft.com
      database: <warehouse_name>
      schema: dbo
      authentication: CLI   # hoặc ActiveDirectoryServicePrincipal, v.v.
```

Cần cài `dbt-fabric`. AutomateDV sẽ tự dùng các macro `fabric__` nhờ `target.type == 'fabric'`.

## 9. Ảnh chụp khả năng T-SQL của Fabric DW (liên quan AutomateDV)

Nguồn: [T-SQL surface area](https://learn.microsoft.com/en-us/fabric/data-warehouse/tsql-surface-area)
và [Data types](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-types) — cập nhật theo tài liệu ngày **2026-06-11**.
Kiểm tra lại 2 trang này trước khi thêm tính năng mới.

| Tính năng | Trạng thái trên Fabric DW | Ảnh hưởng AutomateDV |
|-----------|---------------------------|----------------------|
| `TRUNCATE TABLE` | ✅ Hỗ trợ | Dùng thẳng, bỏ workaround DELETE (mục 3) |
| `MERGE` | ✅ GA | Có thể dùng cho incremental nếu cần |
| `datetime2` / `time` | ✅ nhưng precision tối đa **6** | `fabric__cast_datetime` dùng `DATETIME2(6)` |
| `HASHBYTES` (MD5, SHA2_256, SHA1) | ✅ | Dùng trong `fabric__hash_alg_*` |
| `CONVERT(..., style)` | ✅ | Dùng để đổi hash sang chuỗi hex |
| `char` / `varchar` | ✅ (persisted) | Kiểu cột hash hiện tại `CHAR(n)` |
| `varbinary` | ✅ (persisted) | Lựa chọn thay thế cho hash (xem ghi chú dưới) |
| `binary(n)` cố định | ❌ **không** hỗ trợ cho cột lưu trữ | Vì vậy KHÔNG dùng `BINARY(16)` như SQL Server |
| `nchar` / `nvarchar` | ❌ | Dùng `char`/`varchar` |
| `datetime` / `smalldatetime` | ❌ | Dùng `datetime2` |
| `#temp` tables (session-scoped) | ✅ | An toàn cho materialization tạm |
| `SET ROWCOUNT`, Triggers, Synonyms, Materialized views, Recursive CTE | ❌ | Tránh dùng |

**Ghi chú về kiểu hash (CHAR vs VARBINARY):** hiện dùng `CHAR(n)` chứa hash dạng **hex** — an toàn, đã kiểm chứng.
Vì Fabric nay hỗ trợ `varbinary` (nhưng không hỗ trợ `binary(n)` cố định), có thể đổi `fabric__type_binary`
sang `VARBINARY(16/20/32)` để tiết kiệm dung lượng (lưu byte thô thay vì hex). Nếu đổi, phải chỉnh khớp
`fabric__binary_ghost` và kiểm tra kỹ hành vi `CONVERT(..., style 2)` + `REPLICATE` trên varbinary. Chưa làm vì
CHAR đang chạy ổn và ít rủi ro hơn.
