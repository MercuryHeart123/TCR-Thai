# TCR-Thai — คำแปลภาษาไทยสำหรับ Casket of Reveries

Resource pack แปลภาษาไทยสำหรับม็อดแพ็ก **Casket of Reveries (梦之棺)**
โดย [P1nero](https://github.com/P1neapplell0/TCRCore)

แปลโดย **MercuryHeart123** · แปลจากต้นฉบับภาษาจีนโดยตรง (ไม่ได้แปลผ่านภาษาอังกฤษ)

## ขอบเขต — 2,619 key ใน 10 namespace

### เนื้อหาของโมดแพ็กเอง (1,670 key)

| ไฟล์ | จำนวน key |
|---|---|
| `assets/tcrcore/lang/th_th.json` | 919 |
| `assets/structure_translations/lang/th_th.json` | 416 |
| `assets/ftb_translations/lang/th_th.json` | 335 |
| `assets/tcrcore/texts/` | บทส่งท้าย · เครดิต · ข้อความหลังเครดิต |

### ระบบสกิล (949 key)

หน้า Skill Tree ดึงข้อความจากม็อดของผู้พัฒนาคนอื่นที่โมดแพ็กนำมาใช้ ไม่ได้อยู่ใน TCRCore

| ไฟล์ | จำนวน key | ต้นฉบับที่ใช้แปล |
|---|---|---|
| `assets/epicfight/lang/th_th.json` | 468 | จีน |
| `assets/wom/lang/th_th.json` | 302 | อังกฤษ (ไม่มีจีน) |
| `assets/dodge_parry_reward/lang/th_th.json` | 66 | จีน |
| `assets/epicskills/lang/th_th.json` | 66 | อังกฤษ (ไม่มีจีน) |
| `assets/epicfightx/lang/th_th.json` | 27 | จีน |
| `assets/epicfight_arachne/lang/th_th.json` | 10 | จีน |
| `assets/epicfight_leonidas/lang/th_th.json` | 10 | จีน |

> ยังไม่ได้แปล `datapack_edit.*` ของ Epic Fight (169 key) เพราะเป็น UI ของเครื่องมือ
> แก้ datapack สำหรับผู้สร้างม็อด ผู้เล่นทั่วไปไม่มีทางเห็น

## วิธีใช้

### ฝั่งผู้เล่น

1. โหลด `TCR-Thai.zip`
2. วางในโฟลเดอร์ `resourcepacks` ของโปรไฟล์ม็อดแพ็ก
3. เปิดเกม → Options → Resource Packs → เปิดใช้งาน
4. **Options → Language → เลือก "ไทย"** ← ขั้นตอนนี้ขาดไม่ได้

### ฝั่งเซิร์ฟเวอร์ (ส่งให้ผู้เล่นอัตโนมัติ)

ใส่ใน `server.properties`:

```properties
resource-pack=https://github.com/MercuryHeart123/TCR-Thai/releases/download/v1.1/TCR-Thai.zip
resource-pack-sha1=184e68bdff9f566aa0da88eb7496a023b218b653
require-resource-pack=true
```

> ⚠️ **ใช้ URL ของ Releases ไม่ใช่ `raw.githubusercontent.com`**
> CDN ของ raw cache ไฟล์ราว 5 นาที ทำให้ช่วงหลังอัปเดตจะจ่ายไฟล์เก่าที่ sha1 ไม่ตรงกับใน
> `server.properties` ถ้าตั้ง `require-resource-pack=true` ไว้ ผู้เล่นจะเข้าเซิร์ฟไม่ได้ทั้งหมด
>
> ⚠️ แก้ไฟล์แปลทุกครั้งต้องรัน `package-pack.ps1` ใหม่ ออก release tag ใหม่
> แล้วอัปเดตทั้ง URL และ `resource-pack-sha1` พร้อมกัน

## หลักการแปล

รายละเอียดทั้งหมดอยู่ใน [`TRANSLATION-BRIEF.md`](TRANSLATION-BRIEF.md) สรุปหลัก ๆ:

- **ต้นฉบับภาษาจีนคือแหล่งอ้างอิงหลัก** ไม่ใช่ภาษาอังกฤษ ซึ่งเป็นคำแปลชั้นถัดมาและมีจุดคลาดเคลื่อน
- **ศัพท์กลไกเกมเขียนด้วยอักษรอังกฤษ** (`Boss` `Quest` `Item` `Drop` `Craft` `Skill`)
  ไม่ถอดเป็นอักษรไทย เพราะผู้เล่นไทยอ่านคำเหล่านี้เป็นภาษาอังกฤษอยู่แล้ว
- **ชื่อม็อบและโครงสร้างของ Minecraft เขียนอังกฤษ** (`Pillager` ไม่ใช่ `พิลลาเจอร์`)
- **ชื่อเฉพาะเชิงกวี** (ชื่ออาวุธ ชื่อบทในสมุด Quest) แปลเป็นไทย เน้นให้ได้อารมณ์
- **เลี่ยงคำที่ถูกตามพจนานุกรมแต่คนไทยไม่ใช้** และเลี่ยงสำนวนแปลนิยายกำลังภายใน
- **ชื่อสกิลใช้แบบผสม** — ชื่อที่ตรงกับศัพท์กลไกที่ล็อกไว้คงอักษรอังกฤษ
  (`Roll` `Guard` `Parry` `Stamina`) เพื่อให้ยังเทียบกับคลิปสอน combo ต่างประเทศได้
  ส่วนชื่อท่าโจมตีแปลไทย (`Dancing Edge` → ระบำคมดาบ)

[`REVIEW-DECISIONS.md`](REVIEW-DECISIONS.md) บันทึกผลการตรวจทานรอบหนึ่ง
(ตรวจโดย agent อิสระ 5 ตัว พบ 124 จุด) พร้อมคำตัดสินเรื่องชื่อเฉพาะ 18 ข้อ

### ข้อควรรู้เรื่องต้นฉบับ

ฉบับภาษาอังกฤษของโมดแพ็กเป็นคำแปลชั้นถัดมาจากภาษาจีน และมีจุดคลาดเคลื่อนจริง เช่น
ตัดคำขยายในชื่อมิติทิ้ง ระบุจำนวนม็อบผิด และสลับสรรพนามในบทส่งท้ายจนผู้กระทำเปลี่ยนตัว
คำแปลชุดนี้จึงยึดภาษาจีนเป็นหลักทุกครั้งที่มี

ในทางกลับกัน `wom` และ `epicskills` มีเฉพาะภาษาอังกฤษ (และสะกดผิดหลายจุด เช่น
`allready` `recieved` `wich`) ส่วนนี้จึงแปลตามความหมายที่ตั้งใจ ไม่ได้แปลตามตัวอักษร

## สคริปต์

| ไฟล์ | ใช้ทำอะไร |
|---|---|
| `package-pack.ps1` | บีบอัดเป็น zip แล้วคำนวณ sha1 ให้ |
| `check-progress.ps1` | นับ key ที่แปลแล้ว/ยังไม่แปล |

## License

คำแปลในรีโปนี้จัดทำขึ้นสำหรับม็อดแพ็ก Casket of Reveries ซึ่งเป็นผลงานของ P1nero
และสงวนลิขสิทธิ์ (All Rights Reserved) — รีโปนี้เผยแพร่เฉพาะไฟล์คำแปลที่จัดทำขึ้นใหม่
ไม่ได้แจกจ่ายตัวม็อดหรือทรัพย์สินใด ๆ ของม็อดแพ็กต้นฉบับ

หมายเหตุ: คำแปลส่วน **ระบบสกิล** เป็นของม็อดคนละเจ้ากับ TCRCore (Epic Fight,
Weapons of Miracles ฯลฯ) จึงส่งขึ้น repo ของ TCRCore ไม่ได้ ส่วนนี้จัดทำไว้สำหรับ
ใช้กับเซิร์ฟเวอร์ที่เล่นโมดแพ็กนี้โดยเฉพาะ
