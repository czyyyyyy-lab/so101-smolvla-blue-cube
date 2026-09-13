#!/usr/bin/env bash
set -euo pipefail

export HF_LEROBOT_HOME="${HF_LEROBOT_HOME:-/home/featurize/data}"
export TOKENIZERS_PARALLELISM=false
export PYTHONUNBUFFERED=1

DATASET_ROOT="${DATASET_ROOT:-/home/featurize/data/so101_blue_only_100eps_20260913}"
OUTPUT_DIR="${OUTPUT_DIR:-/home/featurize/work/outputs/smolvla_blue_only_20260913}"

CUDA_VISIBLE_DEVICES=0 lerobot-train \
  --dataset.repo_id=lab-czy/so101_blue_only_100eps_20260913 \
  --dataset.root="$DATASET_ROOT" \
  --dataset.video_backend=pyav \
  --dataset.image_transforms.enable=false \
  --policy.type=smolvla \
  --policy.pretrained_path=lerobot/smolvla_base \
  --policy.repo_id=lab-czy/smolvla_blue_only_20260913 \
  --policy.private=true \
  --policy.push_to_hub=false \
  --policy.device=cuda \
  --policy.use_amp=true \
  --policy.train_expert_only=true \
  --policy.freeze_vision_encoder=true \
  --policy.train_state_proj=true \
  --output_dir="$OUTPUT_DIR" \
  --job_name=smolvla_blue_only_20260913 \
  --batch_size=32 \
  --steps=20000 \
  --save_checkpoint=true \
  --save_freq=4000 \
  --log_freq=20 \
  --num_workers=4 \
  --wandb.enable=false

