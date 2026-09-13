# SO-101 SmolVLA Blue Cube Pick-and-Place

这是一个使用 [LeRobot](https://github.com/huggingface/lerobot) 和 SmolVLA 在 SO-101 机械臂上完成蓝色方块抓取与放置的实验项目。

任务指令：

```text
Put the blue cube into the right box
```

## 实验概况

- 机械臂：SO-101 follower
- 相机：腕部相机 + 顶部相机，640×480、30 FPS
- 数据：100 个示范 episode，共 52,605 帧
- 策略：SmolVLA
- 训练：20,000 steps，batch size 32，AMP
- 微调范围：action expert 与 state projection
- 冻结部分：视觉编码器
- 推荐推理：RTC

固定点位测试中的抓取表现稳定；随机位置测试仍存在一定性能下降，说明后续工作的重点是补充更均衡的空间覆盖数据，而不仅仅是继续降低训练 loss。

## 演示视频

### 固定点位测试

[观看完整视频](media/fixed-placement-test.mp4)（约 6分57秒）

![固定点位测试预览](media/fixed-placement-preview.jpg)

### 随机位置测试

[观看视频上半段](media/random-placement-test-part1.mp4) · [观看视频下半段](media/random-placement-test-part2.mp4)（合计约 11分30秒）

![随机位置测试预览](media/random-placement-preview.jpg)

## 模型与数据

- 模型仓库：[`lab-czy/smolvla_blue_only_20260913`](https://huggingface.co/lab-czy/smolvla_blue_only_20260913)
- 训练数据标识：`lab-czy/so101_blue_only_100eps_20260913`
- 本仓库不包含约 1.2GB 的模型权重；权重由 Hugging Face 托管。

## 相机映射

模型输入字段必须保持如下映射：

| 输入字段 | OpenCV 编号 |
|---|---:|
| `observation.images.wrist` | 0 |
| `observation.images.overhead` | 1 |

不要在此模型上重新映射为 `camera1` / `camera2`。

## 本地 RTC 推理

Windows PowerShell：

```powershell
./scripts/run_rtc.ps1 -PolicyPath "lab-czy/smolvla_blue_only_20260913" -Port "COM24"
```

默认使用偏保守的参数：10 FPS、RTC execution horizon 3、单步相对目标限制 3°。确认运行稳定后，可以逐步提高执行跨度、相对目标限制和控制频率。

## 训练配置

完整训练配置见 [`configs/train_config.json`](configs/train_config.json)，可复用训练命令见 [`scripts/train_smolvla.sh`](scripts/train_smolvla.sh)。本次训练没有划分离线验证集，因此 checkpoint 的最终选择以实机成功率为准。

保存点包括 4K、8K、12K、16K 和 20K。训练 loss 最低的是 20K；在考虑潜在过拟合时，建议同时比较 16K 与 20K。

## 安全提示

- 首次运行时清空机械臂运动范围，并准备随时急停或断电。
- `sync` 或 RTC 都不是硬件安全系统。
- `max_relative_target` 只能限制相邻关节目标变化，不能替代机械限位和现场监护。
- 校准文件、相机编号和机械臂 ID 必须与采集数据保持一致。
