#include "MainHooks.h"
#include "FileLogger.h"
#include "SafeWrite.h"
#include "Patches/All Patches.h"
#include "DFEngine.h"

//GUID ixactengine = {0xbcc782bc, 0x6492, 0x4c22, 0x8c, 0x35, 0xf5, 0xd7, 0x2f, 0xe7, 0x3c, 0x6e};
//GUID ixact3engine = {0xb1ee676a, 0xd9cd, 0x4d2a, 0x89, 0xa8, 0xfa, 0x53, 0xeb, 0x9e, 0x48, 0x0b};

GUID ixactengine = {0x248d8a3b, 0x6256, 0x44d3, 0xa0, 0x18, 0x2a, 0xc9, 0x6c, 0x45, 0x9f, 0x47};
GUID ixact3engine = {0xb1ee676a, 0xd9cd, 0x4d2a, 0x89, 0xa8, 0xfa, 0x53, 0xeb, 0x9e, 0x48, 0x0b};


GUID xaudio = {0x4c5e637a, 0x16c7, 0x4de3, 0x9c, 0x46, 0x5e, 0xd2, 0x21, 0x81, 0x96, 0x2d};		// version 2.3
GUID ixaudio = {0x8bcf1f58, 0x9fe7, 0x4583, 0x8a, 0xc6, 0xe2, 0xad, 0xc4, 0x65, 0xc8, 0xbb};

BOOL __stdcall Hook_GetVersionExA(LPOSVERSIONINFOA lpVersionInformation)
{
	if(GetVersionExAFirstRun)
	{
		GetVersionExAFirstRun=false;
		PrintLog->PrintSys("Calling hooked GetVersionExA.\n");
		UInt32 winmaindata=*((UInt32*)offset_addr(0x00520ba0));
		if(winmaindata==0x83ec8b55)
		{
			// The Steam version of the executable is now unencrypted, so we can start patching.

			PrintLog->PrintInfo("Hooking WinMain.\n");
			WriteRelCall(offset_addr(0x00c9e1c0),(UInt32)&Hook_WinMain);

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

_declspec(naked) void hook_loose_files()
{
	__asm {
		mov cl,1
		mov edi,1
		xor esi,esi
		mov eax,0x00BFDB50
		call eax
		mov cl,1
		xor edi,edi
		mov esi,0
		mov eax,0x00BFDB50
		call eax
		mov eax,0x0051DAC9
		jmp eax
	}
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

		if (!strcmp(pargv[0][i],"test_res"))
		{
			PrintLog->PrintInfo("test_res - Setting resolution to 800x600.\n");
			override_resolution=true;
		}
	}

	// Add patch routines here.
	
	PatchOpenSpy();
	if (!keepfpslimit)
		PatchGOGNoFPSLimit();

	extend_vlib_library_load_list();
	//list_resolutions();
	//enumerate_resolutions();

	patch_override_resolution();
	//patch_localization_strings();

	//SafeWriteBuf(offset_addr(0x00DD8A08),&xaudio,sizeof(xaudio));
	//SafeWriteBuf(offset_addr(0x00DD8A18),&ixaudio,sizeof(ixaudio));

	SafeWrite8(0x00528524,8); // Change number of shadow job threads to 8

	// Set the number of speakers

	UINT32 number_of_speakers = 2;
	UINT32 frequency=48000;

	//SafeWrite8(0x004818E3, number_of_speakers);         // Causes major audio glitches
	SafeWrite8(0x00482B08, number_of_speakers);
	SafeWrite8(0x00482B41, number_of_speakers);
	SafeWrite8(0x00482B96, number_of_speakers);

	SafeWrite32(0x00482B03, frequency);
	SafeWrite32(0x00482B3C, frequency);
	SafeWrite32(0x00482B91, frequency);

	WriteRelJump(0x0051DAC0,(UInt32)&hook_loose_files);

	// Continue to the program's WinMain.

	WinMain_Type OldWinMain=(WinMain_Type)offset_addr(0x00520ba0);
	return (OldWinMain(hInstance, hPrevInstance, lpCmdLine,nShowCmd));
}

