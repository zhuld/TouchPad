# archive/ —— 未使用资源归档

本目录存放经全仓库引用扫描后**确认未被任何代码或资源引用**的文件。
它们**不参与构建**（不在任何 `.qrc` 中、不被 `CMakeLists.txt` 引用），
保留于此仅为备查与将来可能的复用，不会进入编译产物。

如需恢复使用，请把文件移回 `assets/` 下对应目录，并按需登记进该目录的 `.qrc`。

## 归档清单

| 文件 | 原位置 | 判定依据 |
| --- | --- | --- |
| `icons/control.ico` | `icons/` | 全仓库无 `.ico` 引用；`main.cpp` 用窗口图标的是 `icons/control.png` |
| `icons/Maximized.svg` | `icons/` | 无 `Maximized` 路径引用 |
| `icons/MinimizedWindow.svg` | `icons/` | 无 `MinimizedWindow` 路径引用 |
| `icons/touyingji.svg` | `icons/` | 无 `touyingji` 引用 |
| `icons/warn.svg` | `icons/` | 无 `warn` 路径引用（仅有 `Global.buttonWarnColor` 等标识符） |
| `icons/windowed.svg` | `icons/` | 无路径引用（`Main.qml` 中的 `Window.Windowed` 是 Qt 枚举） |
| `images/haishi.png` | `images/` | 无引用；界面用的是 `images/haishi.jpg` |
| `images/shiyi.png` | `images/` | 无引用；界面用的是 `images/shiyi.jpg` |
| `images/shiyilogo.png` | `images/` | 无引用（Logo 由 Config 中的文本属性渲染） |
| `fonts/fonts.txt` | `fonts/` | 仅一行说明文字，未被加载 |
| `sound/click.wav` | `sound/` | 无引用；代码中只有 `onClicked` 等标识符，无音频播放实现 |

## 复核方法

归档判定基于以下事实：仓库 190 处资源引用全部走 `qrc:/icons/...`、
`qrc:/images/...`、`qrc:/fonts/...` 前缀形式，且 `res.qrc`（已拆分至
`assets/*/*.qrc`）为资源的唯一登记处。重新核验某一文件是否被使用：

- 在 `.qml` / `.js` / `.cpp` / `.h` / `*.qrc` / `CMakeLists.txt` 中搜索该文件名（**含去扩展名的前缀式引用**，
  例如 `qrc:/icons/camera` 实际指向 `camera.svg`，直接搜 `camera.svg` 会漏掉）。
- 确认搜索结果中没有出现该文件的资源路径。

## 统计

- 归档文件：**11 个**（icons 6 · images 3 · fonts 1 · sound 1）
- 归档前仓库资源文件 66 个（icons 62 · images 7 · fonts 4 · sound 1），其中 63 个在 `res.qrc` 登记，3 个为未登记且未引用
