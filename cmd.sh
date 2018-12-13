HADOOP_CMD="/data/src/hadoop-2.8.0/bin/hadoop"
STREAM_JAR_PATH="/data/src/hadoop-2.8.0/share/hadoop/tools/lib/hadoop-streaming-2.8.0.jar"

INPUT_FILE_PATH_A="/department/ai/deep/video_fea_13"
INPUT_FILE_PATH_B="/department/ai/deep/video_fea_26"

OUTPUT_FILE_PATH_A="/department/ai/deep/data_13_out"
OUTPUT_FILE_PATH_B="/department/ai/deep/data_256_out"
OUTPUT_FILE_JOIN_PATH="/department/ai/deep/data_join"

$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_FILE_PATH_A
$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_FILE_PATH_B
$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_FILE_JOIN_PATH

# step1: map a
$HADOOP_CMD jar $STREAM_JAR_PATH \
                -input $INPUT_FILE_PATH_A \
                -output $OUTPUT_FILE_PATH_A \
                -jobconf "mapred.job.name=joinfinemapA" \
                -mapper "python mappera.py" \
                -file "./mappera.py"
# step2: map b
$HADOOP_CMD jar $STREAM_JAR_PATH \
                -input $INPUT_FILE_PATH_B \
                -output $OUTPUT_FILE_PATH_B \
                -jobconf "mapred.job.name=joinfinemapB" \
                -mapper "python mapperb.py" \
                -file "./mapperb.py"

# step3: join
$HADOOP_CMD jar $STREAM_JAR_PATH \
                -input $OUTPUT_FILE_PATH_A,$OUTPUT_FILE_PATH_B \
                -output $OUTPUT_FILE_JOIN_PATH \
                -mapper "python mapperjoin.py" \
                -reducer "python reducerjoin.py" \
                -jobconf "mapred.job.name=joinfinemapAB" \
                -jobconf "stream.num.map.output.key.fields=2" \
                -jobconf "num.key.fields.for.partition=1" \
                -file "./reducerjoin.py" \
                -file "./mapperjoin.py"
