#!/bin/bash
mkdir -p checkpoints
archs=('resnet18' 'resnet50' 'mobilenetv2')
w_bits=(3 2 2 4)
a_bits=(3 4 2 4)
for arch in "${archs[@]}"
do
    for w_bit in "${w_bits[@]}"
    do
        for a_bit in "${a_bits[@]}"
        do
            echo Basic quantization arch $arch w_bit $w_bit a_bit $a_bit
            echo Basic quantization arch $arch w_bit $w_bit a_bit $a_bit >> output.txt
            python main_imagenet.py --data_path  /mnt/d/data/ILSVRC/Data/CLS-LOC \
            --arch $arch --n_bits_w $w_bit --channel_wise --n_bits_a $a_bit  --act_quant --order after --wwq --awq --aaq \
            --weight 0.01 --input_prob 1.0 --prob 1.0 --keep_cpu --use_basic_quantization >> output.txt

            echo Ada Quant arch $arch w_bit $w_bit a_bit $a_bit 
            echo Ada Quant arch $arch w_bit $w_bit a_bit $a_bit >> output.txt
            %run -i main_imagenet.py --data_path  /mnt/d/data/ILSVRC/Data/CLS-LOC \
            --arch $arch --n_bits_w $w_bit  --channel_wise --n_bits_a $a_bit --act_quant --order together --wwq --waq --awq --aaq \
            --weight 0.01 --input_prob 1.0 --prob 1.0 --keep_cpu >> output.txt

            echo QDrop arch $arch w_bit $w_bit a_bit $a_bit 
            echo QDrop arch $arch w_bit $w_bit a_bit $a_bit >> output.txt
            python main_imagenet.py --data_path  /mnt/d/data/ILSVRC/Data/CLS-LOC \
            --arch $arch --n_bits_w $w_bit --channel_wise --n_bits_a $a_bit  --act_quant --order together --wwq --waq --awq --aaq \
            --weight 0.01 --input_prob 0.5 --prob 0.5 --keep_cpu >> output.txt
            for((add_levels=1;add_levels<2**w_bit;add_levels++))
            do
                echo Basic quantization arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels
                echo Basic quantization arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels >> output.txt
                python main_imagenet.py --data_path  /mnt/d/data/ILSVRC/Data/CLS-LOC \
                --arch $arch --n_bits_w $w_bit --channel_wise --n_bits_a $a_bit  --act_quant --order after --wwq --awq --aaq \
                --weight 0.01 --input_prob 1.0 --prob 1.0 --keep_cpu --use_basic_quantization \
                --quantize_clipped --additional_levels_num $add_levels >> output.txt

                echo Ada Quant arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels
                echo Ada Quant arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels >> output.txt
                %run -i main_imagenet.py --data_path /mnt/d/data/ILSVRC/Data/CLS-LOC \
                --arch $arch --n_bits_w $w_bit  --channel_wise --n_bits_a $a_bit --act_quant --order together --wwq --waq --awq --aaq \
                --weight 0.01 --input_prob 1.0 --prob 1.0 --keep_cpu --quantize_clipped \
                --additional_levels_num $add_levels >> output.txt

                echo QDrop arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels
                echo QDrop arch $arch w_bit $w_bit a_bit $a_bit additional levels num $add_levels >> output.txt
                python main_imagenet.py --data_path  /mnt/d/data/ILSVRC/Data/CLS-LOC \
                --arch $arch --n_bits_w $w_bit --channel_wise --n_bits_a $a_bit  --act_quant --order together --wwq --waq --awq --aaq \
                --weight 0.01 --input_prob 0.5 --prob 0.5 --keep_cpu \
                --quantize_clipped --additional_levels_num $add_levels >> output.txt

            done
        done
    done
done
