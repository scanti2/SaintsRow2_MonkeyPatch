// Blank DFEngine.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "DFEngine.h"
#include "FileLogger.h"
#include "SafeWrite.h"
#include "MainHooks.h"
#include "iat_functions.h"

static CDFEngine DFEngine;

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	if(ul_reason_for_call==DLL_PROCESS_ATTACH)
	{
		void * old_proc;
		PrintLog = new FileLogger("sr2patch.txt");
		PrintLog->SetLogLevel(4);
		PrintLog->PrintSys("DLL_PROCESS_ATTACH DFEngine.\n");

		UInt32 winmaindata=*((UInt32*)0x00520ba0);
		if(winmaindata!=0x83ec8b55)
			PrintLog->PrintWarn("WinMain sanity check failed. Probably running the Steam encrypted version.\n");

/*
We can't hook WinMain yet as the Steam version is still encrypted at this point, so we need to do some coding gymnastics
to get it to work. We will hook the import address table entry for GetVersionExA. This is part of the Kernel32.dll which 
should be one of the first dlls to load, as the loading routines of other dlls require the routines in it. GetVersionExA
is also called by the common runtime startup routines, which initialise the program before the constructor or WinMain 
are called. Fortunately by this time Steam has decrypted the program data. We then use the hooked routine to hook the 
WinMain entry point.
*/

		HMODULE main_handle=GetModuleHandleA(NULL);
		if(PatchIat(main_handle,"Kernel32.dll", "GetVersionExA", (void *)Hook_GetVersionExA, &old_proc)==S_OK)
			PrintLog->PrintSys("Patched Kernel32.GetVersionExA.\n");
		else
			PrintLog->PrintError("Patching Kernel32.GetVersionExA failed.\n");

	}
	
    return TRUE;
}

CDFEngine *CreateDFEngine(void)
{
	// PrintLog->PrintSys("Calling CreateDFEngine.\n");	
	return(&DFEngine);
}

