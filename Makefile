build_dir = ~/build_dir/top_track
project_dir = ./
output_dir = ./output/

srcs = src/top.cpp src/main.cpp
objs = ${build_dir}/src/top.o \
	   ${build_dir}/src/main.o

.PHONY : target_all init_dir
target_all : init_dir output/bin/out
init_dir : 
	-mkdir -p ${build_dir}
	-mkdir -p ${build_dir}/src
	-mkdir -p ${project_dir}/deploy
	-mkdir -p ${project_dir}/output
	-cp -r ${project_dir}/deploy/* ${project_dir}/output/
	make -C ../invention/

output/bin/out : ${objs} init_dir
	g++ -o output/bin/out ${objs} -lz -L /home/hewenjie/codebase/invention/output/lib/ -linvent

${build_dir}/src/main.o : src/main.cpp 
	g++ -c src/main.cpp -o ${build_dir}/src/main.o -I ./ -I /home/hewenjie/codebase/invention/output/include/
${build_dir}/src/top.o : src/top.cpp
	g++ -c src/top.cpp -o ${build_dir}/src/top.o -I ./

-include ${build_dir}/header.depend
${build_dir}/header.depend : ${srcs}
	g++ -MM ${srcs} > ${build_dir}/header.depend -I ./ -I /home/hewenjie/codebase/invention/output/include/

.PHONY:clean
clean:
	rm -fr output ${objs} ${build_dir}/header.depend
