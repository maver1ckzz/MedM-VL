export PYTHONPATH=$PYTHONPATH:/home/shiym/projects/MedM-VL

deepspeed --include localhost:0,1 --master_port 29501 lvlm/train.py \
    --deepspeed scripts/train/utils/zero3.json \
    --cache_dir_hf /mnt/nfs_share/shiym/ckpts/cache_dir_hf \
    --llm_type qwen2 \
    --llm_name_or_path Qwen/Qwen2.5-3B-Instruct \
    --llm_max_length 512 \
    --llm_padding_side right \
    --llm_attn_implementation flash_attention_2 \
    --tokenizer_use_fast False \
    --encoder_image3d_type m3dclip \
    --encoder_image3d_name_or_path GoodBaiBai88/M3D-CLIP \
    --encoder_image3d_select_layer -1 \
    --encoder_image3d_select_feature patch \
    --connector_image3d_type spatial_pooling \
    --connector_image3d_name mlp2x_gelu \
    --data_path /hdd/shiym/datasets_processed/MedM/m3d_pretrain.json \
    --conv_version pretrain_image3d \
    --image3d_path /hdd/shiym/datasets/medical-image-analysis/M3D/npys_256 \
    --training_recipe common \
    --tune_type_llm frozen \
    --tune_type_encoder_image3d frozen \
    --tune_type_connector_image3d full \
    --bf16 True \
    --gradient_checkpointing True \
    --output_dir /hdd/shiym/work_dirs/MedM-VL/MedM-VL-qwen2-m3dclip-pretrain \
    --dataloader_num_workers 8 \
    --dataloader_pin_memory True \
    --dataloader_persistent_workers True \
    --num_train_epochs 3 \
    --per_device_train_batch_size 32 \
    --gradient_accumulation_steps 1 \
    --learning_rate 1e-4 \
    --weight_decay 0.0 \
    --warmup_ratio 0.03 \
    --lr_scheduler_type cosine \
    --eval_strategy no \
    --save_strategy no \
    --report_to tensorboard \
    --logging_steps 1
