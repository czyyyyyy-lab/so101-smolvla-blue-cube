param(
    [string]$PolicyPath = "lab-czy/smolvla_blue_only_20260913",
    [string]$Port = "COM24",
    [string]$RobotId = "my_awesome_follower_arm",
    [string]$CalibrationDir = "$env:USERPROFILE\.cache\huggingface\lerobot\calibration\robots\so_follower"
)

lerobot-rollout `
  --strategy.type=base `
  --inference.type=rtc `
  --inference.rtc.execution_horizon=3 `
  --inference.rtc.max_guidance_weight=10.0 `
  --inference.rtc.prefix_attention_schedule=EXP `
  --inference.queue_threshold=10 `
  --policy.path="$PolicyPath" `
  --robot.type=so101_follower `
  --robot.port="$Port" `
  --robot.id="$RobotId" `
  --robot.calibration_dir="$CalibrationDir" `
  --robot.disable_torque_on_disconnect=true `
  --robot.max_relative_target=3.0 `
  --robot.cameras='{wrist: {type: opencv, index_or_path: 0, width: 640, height: 480, fps: 30}, overhead: {type: opencv, index_or_path: 1, width: 640, height: 480, fps: 30}}' `
  --task="Put the blue cube into the right box" `
  --fps=10 `
  --device=cuda `
  --display_data=false `
  --return_to_initial_position=false `
  --play_sounds=true

