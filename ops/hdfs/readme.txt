用途：
    检查文件的租约状态，
    读取要恢复租约状态的文件并恢复

设计思路：
    读取所有 json 数据文件的最近三天的目录，
    检查目录，将需要恢复租约状态的文件恢复

调度如下：
    uhadoop-mzwc2w-task2: 20 23 * * * source /etc/profile; source ~/.bashrc; /bin/bash /data/soft/PY_Tools/com/itcode/ops/hdfs/check_openforwrite.sh
    uhadoop-mzwc2w-task2: 20 08 * * * source /etc/profile; source ~/.bashrc; /bin/bash /data/soft/PY_Tools/com/itcode/ops/hdfs/check_openforwrite.sh
