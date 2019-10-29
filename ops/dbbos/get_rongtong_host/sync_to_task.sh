#! /bin/bash

# 定时同步最新开店信息到每台服务器

src_dir="/data/soft/get_rongtong_host"
desc_dir="/data/app/dev/data_biz/etl/rongtong_datax/dbbos"
host_shop="host_shop.txt"
add_partition="add_partition_modult.sql"
src_host_file="${src_dir}/${host_shop}"
src_add_partition_file="${src_dir}/${add_partition}"
if [ -s "${src_host_file}"  -a -s "${src_add_partition_file}" ]; then
   clush -g rt --copy ${src_dir}/${host_shop} --dest=${desc_dir}/${host_shop}
   clush -g rt --copy ${src_dir}/${add_partition} --dest=${desc_dir}/${add_partition}
fi



