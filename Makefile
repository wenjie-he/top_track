build_dir = /home/hewenjie/build_dir/top_track/
project_dir = ./
output_dir = ./output/
third_party = /home/hewenjie/codebase/wenjie-he/invention/

out_include = $(foreach n, $(third_party), -I $(n)output/include)

srcs1 = src/main.cpp src/top.cpp
srcs2 = src/main.cpp src/top.cpp
objs1 = $(foreach n, $(srcs1), $(build_dir)$(n).o)
objs2 = $(foreach n, $(srcs2), $(build_dir)$(n).o)
deps1 = $(foreach n, $(srcs1), $(build_dir)$(n).d)
deps2 = $(foreach n, $(srcs2), $(build_dir)$(n).d)

target1 = $(build_dir)output/lib/target1
target2 = $(build_dir)output/lib/target2

.PHONY : target_all init_dir
target_all : init_dir $(target1) $(target2)
init_dir : 
	echo "init dir please"
$(target1) : $(objs1) $(target2) $(target3)
	g++ -o $(target1) $(objs1) $(target2) $(target3)
$(target2) : $(objs2)
	g++ -o $(target2) $(objs2)
$(target3) :
	make -C /home/hewenjie/codebase/wenjie-he/target3

# building objects
$(objs1):$(build_dir)%.o:%
	g++ -c $< -o $@ -I ./ -I $(out_include)
$(objs2):$(build_dir)%.o:%
	g++ -c $< -o $@ -I ./ -I $(out_include)

#building dependence
$(deps1):$(build_dir)%.d:%
	g++ -MM $< -I ./ -I $(out_include) | sed -r "s#(^.*.o):()#$@ $(build_dir)$<.o:#g" > $@;
$(deps2):$(build_dir)%.d:%
	g++ -MM $< -I ./ -I $(out_include) | sed -r "s#(^.*.o):()#$@ $(build_dir)$<.o:#g" > $@;

-include $(deps1) $(deps2)

clean:
	rm $(objs) $(deps)
