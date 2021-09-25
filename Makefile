output_dir = /home/hewenjie/build_dir/
project = wenjie-he/top_track/
build_dir = $(output_dir)$(project)

totol_include = -I ./ -I $(output_dir)$(third_party)

#process src
srcs = src/main.cpp src/top.cpp
objs = $(foreach n, $(srcs1), $(build_dir)$(n).o)
deps = $(foreach n, $(srcs1), $(build_dir)$(n).d)
$(objs) : $(build_dir)%.o : %
	g++ -c $< -o $@ -I $(total_include)
$(deps) : $(build_dir)%.d : %
	g++ -MM $< $(total_include) | sed -r "s#(^.*.o):()#$@ $(build_dir)$<.o:#g" > $@;
-include $(deps)

#proceess depend libs
third_party = wenjie-he/invention/
depend_name = lib
depend_libs = $(output_dir)$(third_party)lib/libtest1.so $(output_dir)$(third_party)lib/libtest2.so
$(depend_libs) :
	make -C third_party $(lib)

#process depend protos
third_party = wenije-he/invention/
depend_name = idl
depend_protos = $(third_party)idl/idl.proto $(third_party)idl/rec/rec.proto
depend_proto_objs = $(foreach n, $(depend_protos), $(output_dir)$(n).cpp.o)
$(depend_proto_objs) : 
	make -C third_party $(idl)

#process local libs
local_name = local_lib
local_libs = $(build_dir)output/libs/liblocal1.so $(build_dir)output/libs/liblocal2.so
local_lib_src = src/test1.cpp src/test2.cpp
local_lib_objs = $(foreach n, $(local_lib_src), $(output_dir)$(n).cpp.o)
$(local_lib_objs) : $(build_dir)%.o : %
	g++ -c $< -o $@ $(total_include)
$(local_lib_deps) : $(build_dir)%.d : %
	g++ -MM $< $(total_include) | sed -r "s#(^.*.o):()#$@ $(build_dir)$<.o:#g" > $@;
-include $(local_lib_deps)

#process local protos
local_protos = idl/idl.proto idl/rec/rec.proto
local_proto_objs = $(foreach n, $(local_protos), $(output_dir)$(n).cpp.o)
local_proto_deps = $(foreach n, $(local_protos), $(output_dir)$(n).cpp.d)
local_proto_objs : $(build_dir)%.cpp.o : %
	g++ c $< -o $@ $(total_include)
$(local_proto_deps) : %.d : %
	g++ -MM $< $(total_include) | sed -r "s#(^.*.o):()#$@ $<.o:#g" > $@;
-include $(local_proto_deps)

#process target
target1 = $(build_dir)$(output)a.out
target2 = $(local_libs)
target1 : $(objs) $(depend_libs) $(depend_proto_objs) $(local_libs)
	g++ -o $(target) $<
target_all : $(init_dir) $(target1) $(target2)

init_dir : 
	echo "init dir please"

.PHONY : clean
clean:
	rm $(objs) $(deps)
