#pragma once

#define ADDED_VINT_LIBRARIES 1

static char *new_vlib_library_load_list[25];
#if ADDED_VINT_LIBRARIES>0
	static char *added_libraries[]={"monkey_patch.vpp"};
#endif

void extend_vlib_library_load_list();