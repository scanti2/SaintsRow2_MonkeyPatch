/*
	Adds extra *.vpp_pc to the vint library loading list. You can only add an extra 9 libraries, otherwise you'll start
	overwriting existing code. The filename must not exceed 64 characters.
*/

#include "vlib_library_load_extender.h"
#include <string.h>
#include "SafeWrite.h"

void extend_vlib_library_load_list()
{
	memcpy(&new_vlib_library_load_list,(void*)(0x00E98A28),16*4);
	
	#if ADDED_VINT_LIBRARIES>0
		for (int i=0; i<ADDED_VINT_LIBRARIES; i++)
			new_vlib_library_load_list[16+i]=added_libraries[i];
	#endif

	SafeWrite32(0x0051DAD2,(UInt32)&new_vlib_library_load_list);
	SafeWrite8(0x0051DB38,(16+ADDED_VINT_LIBRARIES)*4);

	return;
}