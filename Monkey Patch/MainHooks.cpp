#include "MainHooks.h"
#include "FileLogger.h"
#include "SafeWrite.h"
#include "Patches/All Patches.h"

BOOL __stdcall Hook_GetVersionExA(LPOSVERSIONINFOA lpVersionInformation)
{
	if(GetVersionExAFirstRun)
	{
		GetVersionExAFirstRun=false;
		PrintLog->PrintSys("Calling hooked GetVersionExA.\n");
		UInt32 winmaindata=*((UInt32*)0x00520ba0);
		if(winmaindata==0x83ec8b55)
		{
			// The Steam version of the executable is now unencrypted, so we can start patching.

			PrintLog->PrintInfo("Hooking WinMain.\n");
			WriteRelCall(0x00c9e1c0,(UInt32)&Hook_WinMain);

			// Add patch routines here for patches that need to be run at crt startup, usually for patching constructors.
			// Be very careful you can break things easily.

			// The game timer constructor sets up the game's timing so this needs to patch before the constructor is called.
			PatchQueryPerformance();
		}
		else
		{
			PrintLog->PrintError("WinMain sanity check failed in GetVersionExA.\n");
		}
	}
	else
	{
		PrintLog->PrintInfo("Calling hooked GetVersionExA more than once. Skipping patch code.");
	}

	return(GetVersionExA(lpVersionInformation));
}

int WINAPI Hook_WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
{
	char NameBuffer[260];
	PIMAGE_DOS_HEADER dos_header;
	PIMAGE_NT_HEADERS nt_header;
	MEMORYSTATUSEX memory_info;
	HMODULE main_handle;
	
	PrintLog->PrintSys("Calling Hooked WinMain.\n");

	main_handle=GetModuleHandleA(NULL);
	GetModuleFileNameA(main_handle,NameBuffer,260);
	PrintLog->PrintInfo("Module name = %s\n",NameBuffer);
	dos_header=(PIMAGE_DOS_HEADER)main_handle;
	nt_header=(PIMAGE_NT_HEADERS)((DWORD)main_handle+dos_header->e_lfanew);
	
	if (nt_header->FileHeader.Characteristics&IMAGE_FILE_LARGE_ADDRESS_AWARE)
		PrintLog->PrintInfo("Game is large address aware. You have more memory available for mods.\n");
	else
		PrintLog->PrintInfo("Game is not large address aware. You are probably running the Steam version.\n");

	memory_info.dwLength=sizeof(memory_info);
	GlobalMemoryStatusEx(&memory_info);
	PrintLog->PrintInfo("Memory allocated to process at startup = %I64dMB, memory free = %I64dMB.\n",memory_info.ullTotalVirtual/1048576,memory_info.ullAvailVirtual/1048576);

	for (int i=1; i<*pargc; i++)
	{
		if (!strcmp(pargv[0][i],"keepfpslimit"))
		{
			PrintLog->PrintInfo("keepfpslimit - Keeping GOG FPS limiter.\n");
			keepfpslimit=true;
		}
	}

	// Add patch routines here.
	
	PatchOpenSpy();
	if (!keepfpslimit)
		PatchGOGNoFPSLimit();

	extend_vlib_library_load_list();
	list_resolutions();
	override_resolutions();


	// Continue to the program's WinMain.

	WinMain_Type OldWinMain=(WinMain_Type)0x00520ba0;
	return (OldWinMain(hInstance, hPrevInstance, lpCmdLine,nShowCmd));
}

