#! /bin/bash -x

#sshpass -p gvU4p5hyoA ssh sa_cluster@10.19.144.247 "source /etc/profile; hostname;\
#ifconfig"

#sshpass -p gvU4p5hyoA ssh sa_cluster@10.19.144.247 "source /etc/profile; hostname;\
##ifconfig"



#删除虚拟属性：
spadmin external_view external_property remove  -p production -n dim_goods_id
spadmin external_view external_property remove  -p production -n dim_category_id
spadmin external_view external_property remove  -p production -n goods_name
spadmin external_view external_property remove  -p production -n category_name_sensors
spadmin external_view external_property remove  -p production -n mcategory_code
spadmin external_view external_property remove  -p production -n mcategory_name
spadmin external_view external_property remove  -p production -n bcategory_code
spadmin external_view external_property remove  -p production -n bcategory_name
spadmin external_view external_property remove  -p production -n workshop_code
spadmin external_view external_property remove  -p production -n work_shop_name
spadmin external_view external_property remove  -p production -n small_group_code
spadmin external_view external_property remove  -p production -n small_group_name
spadmin external_view external_property remove  -p production -n class_code
spadmin external_view external_property remove  -p production -n class_name
spadmin external_view external_property remove  -p production -n group_code
spadmin external_view external_property remove  -p production -n group_name
spadmin external_view external_property remove  -p production -n dept_code
spadmin external_view external_property remove  -p production -n dept_name


#移除维度表：remove
spadmin external_view external_dimension_table remove  -p production -t dim.dim_category_goods_sensors




#把维度表加入神策系统中:
#spadmin external_view external_dimension_table add  -p production -t dim.dim_category_goods_sensors -e "regexp_replace(COALESCE(events.yh_productId, events.productID, ''), '[^0-9]+', '') = dim.dim_category_goods_sensors.dim_goods_id"
spadmin external_view external_dimension_table add  -p production -t dim.dim_category_goods_sensors -e "regexp_replace(events.yh_productId, '[^0-9]+', '') = dim.dim_category_goods_sensors.dim_goods_id"

#创建虚拟属性：
spadmin external_view external_property add  -p production  -n dim_goods_id  -t STRING -c '后台_商品ID'  -e dim.dim_category_goods_sensors.dim_goods_id
spadmin external_view external_property add  -p production  -n dim_category_id  -t STRING -c '后台_品类id'  -e dim.dim_category_goods_sensors.dim_category_id
spadmin external_view external_property add  -p production  -n goods_name  -t STRING -c '后台_商品名称'  -e dim.dim_category_goods_sensors.goods_name
spadmin external_view external_property add  -p production  -n category_name_sensors  -t STRING -c '后台_品类名称'  -e dim.dim_category_goods_sensors.category_name_sensors
spadmin external_view external_property add  -p production  -n mcategory_code  -t STRING -c '后台_中类编码'  -e dim.dim_category_goods_sensors.mcategory_code
spadmin external_view external_property add  -p production  -n mcategory_name  -t STRING -c '后台_中类名称'  -e dim.dim_category_goods_sensors.mcategory_name
spadmin external_view external_property add  -p production  -n bcategory_code  -t STRING -c '后台_大类编码'  -e dim.dim_category_goods_sensors.bcategory_code
spadmin external_view external_property add  -p production  -n bcategory_name  -t STRING -c '后台_大类名称'  -e dim.dim_category_goods_sensors.bcategory_name
spadmin external_view external_property add  -p production  -n workshop_code  -t STRING -c '后台_工坊编码'  -e dim.dim_category_goods_sensors.workshop_code
spadmin external_view external_property add  -p production  -n work_shop_name  -t STRING -c '后台_工坊名称'  -e dim.dim_category_goods_sensors.work_shop_name
spadmin external_view external_property add  -p production  -n small_group_code  -t STRING -c '后台_小商行编码'  -e dim.dim_category_goods_sensors.small_group_code
spadmin external_view external_property add  -p production  -n small_group_name  -t STRING -c '后台_小商行名称'  -e dim.dim_category_goods_sensors.small_group_name
spadmin external_view external_property add  -p production  -n class_code  -t STRING -c '后台_课组编码'  -e dim.dim_category_goods_sensors.class_code
spadmin external_view external_property add  -p production  -n class_name  -t STRING -c '后台_课组名称'  -e dim.dim_category_goods_sensors.class_name
spadmin external_view external_property add  -p production  -n group_code  -t STRING -c '后台_商行编码'  -e dim.dim_category_goods_sensors.group_code
spadmin external_view external_property add  -p production  -n group_name  -t STRING -c '后台_商行名称'  -e dim.dim_category_goods_sensors.group_name
spadmin external_view external_property add  -p production  -n dept_code  -t STRING -c '后台_部类编码'  -e dim.dim_category_goods_sensors.dept_code
spadmin external_view external_property add  -p production  -n dept_name  -t STRING -c '后台_部类名称'  -e dim.dim_category_goods_sensors.dept_name


##查看生产环境的维度表：
##展示所有虚拟属性：
spadmin external_view external_dimension_table list -p production
spadmin external_view external_property list -p production
