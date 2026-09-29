# 使用说明 / User Guide

> Finesse3 Optics Simulator — macOS / Linux Edition
> 中英双语操作指南 · Bilingual step-by-step guide

本指南介绍如何**连接各元件**、**设置高斯光束**以及**搭建光学腔**。
This guide explains how to **connect components**, **set up a Gaussian beam**, and **build an optical cavity**.

---

## 目录 / Table of Contents

1. [界面速览 / Interface at a glance](#1-界面速览--interface-at-a-glance)
2. [连接各元件 / Connecting components](#2-连接各元件--connecting-components)
3. [设置高斯光束 / Setting up a Gaussian beam](#3-设置高斯光束--setting-up-a-gaussian-beam)
4. [搭建光学腔 / Building an optical cavity](#4-搭建光学腔--building-an-optical-cavity)
5. [运行与扫描 / Running & sweeping](#5-运行与扫描--running--sweeping)
6. [完整示例 / Complete worked example](#6-完整示例--complete-worked-example)
7. [常见问题 / FAQ](#7-常见问题--faq)

---

## 1. 界面速览 / Interface at a glance

| 区域 / Area | 作用 / Purpose |
|-------------|----------------|
| 左侧库 / Library (left) | 拖拽元件到画布 / Drag components onto the canvas |
| 中间画布 / Canvas (center) | 摆放与连线 / Place and connect components |
| 右侧属性 / Properties (right) | 编辑选中项的参数 / Edit parameters of the selected item |
| 底部输出 / Output (bottom) | KatScript 预览、图表、CCD 图像 / KatScript preview, charts, CCD images |

**快捷键 / Shortcuts**

- **Shift + 拖拽**：锁定水平/垂直方向移动 / lock movement to one axis.
- **Delete**：删除选中项 / remove the selected item.
- **右键**：上下文菜单 / context menu.

> 语言切换：点击标题栏左侧的 **EN / 中** 按钮。
> Language: click the **EN / 中** button at the left of the header.

---

## 2. 连接各元件 / Connecting components

### 2.1 基本步骤 / Basic steps

1. **放置元件 / Place a component** — 从左侧库拖拽一个元件到画布。
   Drag a component from the left library onto the canvas.
2. **找到端口 / Find the ports** — 每个元件边缘有红色小圆点，代表光学端口（`p1`, `p2`, …）。
   Each component has small red dots on its edges — these are optical ports (`p1`, `p2`, …).
3. **拖拽连线 / Drag to connect** — 从一个元件的端口圆点拖到另一个元件的端口圆点，松开即建立连接。
   Drag from one port dot to another port dot and release to create a connection.
4. **重复 / Repeat** — 继续连接，直到光路完整。
   Keep connecting until the optical path is complete.

> 连接在 Finesse 中对应一个 **space（空间）**，例如 `s s1 bs1.p2 m1.p1 L=3`。
> A connection corresponds to a Finesse **space**, e.g. `s s1 bs1.p2 m1.p1 L=3`.

### 2.2 编辑连接 / Editing a connection

点击连接线，右侧属性面板显示 / Click a connection line; the Properties panel shows:

| 字段 / Field | 含义 / Meaning |
|--------------|----------------|
| Port selectors | 切换连接的是哪两个端口 / which two ports are linked |
| Name | 空间名称，如 `s1` / space name, e.g. `s1` |
| **Length (L)** | 光程长度，单位米 / optical path length in metres |
| Extra param | 附加参数，如 `nr`（折射率）/ extra params, e.g. `nr` (refractive index) |

### 2.3 端口编号规则 / Port numbering

| 元件 / Component | 端口 / Ports |
|------------------|--------------|
| Laser (L) | `p1` 输出 / output |
| Mirror (M) | `p1`, `p2`（两面）/ both sides |
| Beamsplitter (BS) | `p1`–`p4`（四端口）/ four ports |
| Lens (Ln) | `p1`, `p2` |
| Photodetector (PD) | `p1` 输入 / input |
| CCD | `p1` 输入 / input |

### 2.4 连线小技巧 / Tips

- **Shift + 拖拽** 可锁定方向，方便对齐 / hold **Shift** while dragging to lock the direction.
- 连线后可在属性里修改 **L**，无需重新连线 / change **L** in Properties instead of re-drawing.
- 若端口连错，点击连线后重新选择端口即可 / to fix a wrong port, click the line and re-select the ports.

---

## 3. 设置高斯光束 / Setting up a Gaussian beam

高斯光束用于定义入射光的**束腰**，是 CCD 成像和腔模式匹配的基础。
A Gaussian beam defines the **beam waist** of the input light — the basis for CCD imaging and cavity mode matching.

### 3.1 添加 Gauss 元件 / Add a Gauss component

1. 从左侧库拖拽 **Gauss**（图标 `G`）到画布。
   Drag **Gauss** (icon `G`) from the library onto the canvas.
2. 把它连接到光路的**起点**（例如激光之后、第一个元件之前）。
   Connect it to the **start** of the optical path (e.g. right after the laser).
3. 点击该元件，在右侧属性面板设置参数。
   Click it and set the parameters in the Properties panel.

### 3.2 参数说明 / Parameters

| 参数 / Param | 含义 / Meaning | 默认值 / Default |
|--------------|----------------|------------------|
| **w0** | 束腰半径（米）/ beam waist radius (m) | `1e-3` (1 mm) |
| **z** | 束腰相对节点的位置（米）/ waist position relative to the node (m) | `0` |
| `w0x`, `w0y` | x/y 方向束腰（高级）/ per-axis waist (advanced) | — |
| `zx`, `zy` | x/y 方向束腰位置（高级）/ per-axis waist position (advanced) | — |

> 在 Finesse 中对应 `gauss g1 node w0=1e-3 z=0`。
> In Finesse this becomes `gauss g1 node w0=1e-3 z=0`.

### 3.3 使用变量 / Using variables

推荐用变量定义束腰，便于扫描 / define the waist with a variable so you can sweep it:

1. 点击工具栏 **Vars**，添加 / click **Vars** in the toolbar and add:
   ```
   Name: w0_val    Value: 1e-3
   ```
2. 在 Gauss 的 **w0** 字段填入 / enter in the Gauss **w0** field:
   ```
   {w0_val}
   ```
3. 之后修改 `w0_val` 即可整体调整光束 / later, edit `w0_val` to change the beam everywhere.

### 3.4 与 CCD 配合 / With a CCD

1. 在光路末端放置 **CCD** 并连接。
   Place a **CCD** at the end of the path and connect it.
2. 确保 **Gauss** 位于 CCD 的**上游**（光先经过 Gauss 定义，再到 CCD）。
   Make sure the **Gauss** is **upstream** of the CCD.
3. 点击 **Run**，然后在输出面板点击 **View CCD** 查看光斑。
   Click **Run**, then **View CCD** in the output panel to see the beam profile.

---

## 4. 搭建光学腔 / Building an optical cavity

有两种方式 / two ways:

### 4.1 方式 A：用两个反射镜组成腔（推荐，最直观）/ Method A: two mirrors (recommended)

这是最常用的法布里–珀罗腔 / this is the standard Fabry–Pérot cavity:

1. 放置两个 **Mirror**（`m1`, `m2`）。
   Place two **Mirror** components (`m1`, `m2`).
2. 用一条连接把 `m1.p2` 连到 `m2.p1`，**Length (L)** 设为腔长（如 `3`）。
   Connect `m1.p2` → `m2.p1` and set **Length (L)** to the cavity length (e.g. `3`).
3. 设置镜面反射率 / set the mirror reflectivity:
   - `m1`: `R=0.99`, `T=0.01`
   - `m2`: `R=0.99`, `T=0.01`
4. 若要腔稳定，给镜面加**曲率半径**（高级参数）/ for a stable cavity, add **radius of curvature** (advanced):
   - `m1`: `Rc=-3`（凹面）/ concave
   - `m2`: `Rc=3`（凹面，与 m1 相对）/ concave, facing m1

> 对应 KatScript / equivalent KatScript:
> ```
> m m1 R=0.99 T=0.01 Rc=-3
> s cav m1.p2 m2.p1 L=3
> m m2 R=0.99 T=0.01 Rc=3
> ```

### 4.2 方式 B：用 Cavity 元件 / Method B: the Cavity component

1. 拖拽 **Cavity**（图标 `Cav`）到画布。
   Drag **Cavity** (icon `Cav`) onto the canvas.
2. 把它连接到腔的两个端口之间。
   Connect it between the two cavity ports.
3. 在属性面板用 **Extra param** 添加腔参数（如 `finesse`、`F` 等）。
   Use **Extra param** in Properties to add cavity parameters (e.g. `finesse`, `F`).

> Cavity 元件在 Finesse 中对应 `cav` 命令，适合快速定义腔的精细度等整体属性。
> The Cavity component maps to the Finesse `cav` command — handy for defining overall
> properties such as finesse.

### 4.3 腔长与稳定性 / Length & stability

- **腔长 L** 决定自由光谱范围 $\mathrm{FSR} = c / (2L)$。
  The **length L** sets the free spectral range $\mathrm{FSR} = c / (2L)$.
- 稳定腔要求 $0 \le g_1 g_2 \le 1$，其中 $g_i = 1 - L / R_{c,i}$。
  A stable cavity requires $0 \le g_1 g_2 \le 1$, with $g_i = 1 - L / R_{c,i}$.
- 用变量定义腔长，便于扫描 / define the length as a variable for sweeping:
  ```
  Name: cav_len    Value: 3.0
  ```
  然后在连接线的 **L** 填 `{cav_len}` / then set the connection **L** to `{cav_len}`.

---

## 5. 运行与扫描 / Running & sweeping

### 5.1 静态运行 / Static run

点击 **Run**（`noxaxis`）/ click **Run** (`noxaxis`):

- 显示生成的 KatScript / shows the generated KatScript
- 显示各探测器读数 / shows detector readouts
- 若 CCD 上游有 Gauss/Cavity，显示光斑 / shows the beam profile if a Gauss/Cavity is upstream of the CCD

### 5.2 参数扫描 / Parameter sweep

点击 **Sweep**（`xaxis`）/ click **Sweep** (`xaxis`):

1. 点击 **+ Add Param** 添加要扫描的参数（如 `m2.phi`）。
   Click **+ Add Param** and pick a parameter (e.g. `m2.phi`).
2. 设置范围与步数 / set the range and number of steps.
3. 选择 **Together**（同时扫描）或 **Separate**（分别扫描）。
   Choose **Together** or **Separate**.
4. 点击 **Run**，Chart.js 绘制探测器输出随参数的变化。
   Click **Run**; Chart.js plots detector output vs. the swept parameter.

> 解调探测器（`pd1`/`pd2`）会同时显示幅度与相位。
> Demodulated detectors (`pd1`/`pd2`) show both amplitude and phase.

---

## 6. 完整示例 / Complete worked example

一个带高斯光束的迈克尔逊干涉仪 / a Michelson interferometer with a Gaussian beam:

```python
# 变量 / variables
arm_len = 3.0
delta_len = 0.001
bs_r = 0.5
m_r = 0.99
w0_val = 1e-3

model.parse("""
l L0 P=1
gauss g1 L0.p1 w0={w0_val} z=0
s s0 L0.p1 bs1.p1 L=0.5
bs bs1 R={bs_r} T=1-{bs_r}
s s1 bs1.p2 m1.p1 L={arm_len}
m m1 R={m_r} T=1-{m_r}
s s2 bs1.p3 m2.p1 L={arm_len+delta_len}
m m2 R={m_r} T=1-{m_r}
s s3 bs1.p4 pd1.p1 L=0.5
pd pd1
""")
```

**操作步骤 / Steps**

1. 把上面整段粘贴到导入框，点击 **Import**。
   Paste the whole block into the import box and click **Import**.
2. 画布上出现激光、高斯光束、分束器、两面镜子和探测器。
   The canvas shows the laser, Gaussian beam, beamsplitter, two mirrors and a detector.
3. 点击 **Run** 查看 `pd1` 读数。
   Click **Run** to see the `pd1` readout.
4. 点击 **Sweep**，扫描 `m2.phi` 从 0 到 360 度，观察干涉条纹。
   Click **Sweep**, scan `m2.phi` from 0 to 360 degrees, and watch the interference fringes.

---

## 7. 常见问题 / FAQ

**Q: 连线连不上？/ Can't connect two components?**
A: 确认拖拽的是**端口圆点**（红色小点），而不是元件本体。端口必须一进一出。
Make sure you drag from the **port dots** (small red dots), not the component body. Ports must be in/out.

**Q: CCD 没有图像？/ No CCD image?**
A: 检查 CCD 上游是否有 **Gauss** 或 **Cavity** 定义了光束。没有光束定义就没有光斑。
Check that a **Gauss** or **Cavity** upstream defines the beam. No beam definition → no profile.

**Q: 腔不稳定 / Cavity unstable?**
A: 检查 $g_1 g_2$ 是否在 $[0,1]$ 内，必要时调整镜面曲率半径 `Rc` 或腔长 `L`。
Check that $g_1 g_2 \in [0,1]$; adjust the mirror curvature `Rc` or the length `L`.

**Q: 参数里的 `{var}` 不生效？/ `{var}` in a parameter doesn't work?**
A: 先在 **Vars** 面板定义同名变量，再在参数里用 `{name}` 引用。
Define the variable in the **Vars** panel first, then reference it as `{name}`.

**Q: 如何导出模型？/ How to export?**
A: 输出面板的 **Export .kat** 导出 KatScript，**Export .ipynb** 导出 Jupyter 笔记本。
Use **Export .kat** for KatScript and **Export .ipynb** for a Jupyter notebook.

---

更多细节见 [USER_MANUAL.md](USER_MANUAL.md) / [USER_MANUAL.pdf](USER_MANUAL.pdf)。
For more details, see [USER_MANUAL.md](USER_MANUAL.md) / [USER_MANUAL.pdf](USER_MANUAL.pdf).
