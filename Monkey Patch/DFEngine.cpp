// Blank DFEngine.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "DFEngine.h"
#include "FileLogger.h"
#include "SafeWrite.h"
#include "MainHooks.h"
#include "iat_functions.h"
#include <vector>

static CDFEngine DFEngine;
static CDFObjectInstance fake_CDFObject;

int address_offset=0;

static std::vector<std::wstring> find_billboards_list;
static int number_of_billboard_files;

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

		HMODULE main_handle=GetModuleHandleA(NULL);
		
		if((unsigned int)main_handle!=0x0400000)
		{
			address_offset=(unsigned int)main_handle-0x0400000;
			PrintLog->PrintWarn("Executable base doesn't match default. Base = 0x%08X offset %i\n",(unsigned int)main_handle, address_offset);
			PrintLog->PrintWarn("You probably have the Manditory ASLR setting enabled. This patch will still work.\n");
			PrintLog->PrintWarn("However, it's recommended that you disable the setting globally (as it can cause instabilty)\n");
			PrintLog->PrintWarn("and only enable it for programs you wish to harden.\n");
		}

		UInt32 winmaindata=*((UInt32*)offset_addr(0x00520ba0));
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


		if(PatchIat(main_handle,"Kernel32.dll", "GetVersionExA", (void *)Hook_GetVersionExA, &old_proc)==S_OK)
			PrintLog->PrintSys("Patched Kernel32.GetVersionExA.\n");
		else
			PrintLog->PrintError("Patching Kernel32.GetVersionExA failed.\n");

	}
	
    return TRUE;
}

CDFEngine *CreateDFEngine(void)
{
	HMODULE dll_loaded;
	typedef CDFEngine *(__stdcall *CreateDFEngine_type)();
	CreateDFEngine_type redirect_CreateDFEngine;
	PrintLog->PrintSys("Calling CreateDFEngine.\n");
	
	dll_loaded=LoadLibraryA("pass_DFEngine.dll");

	if(dll_loaded)
	{
		PrintLog->PrintInfo("Passthrough DFEngine exists. Attempting passthrough.\n");
		redirect_CreateDFEngine=(CreateDFEngine_type)GetProcAddress(dll_loaded,"CreateDFEngine");
		if (redirect_CreateDFEngine)
		{
			PrintLog->PrintInfo("Passthrough succeeded.\n");
			return(redirect_CreateDFEngine());
		}
		else
			PrintLog->PrintWarn("Passthrough failed. Using fake DFEngine.\n");
	}

	set_up_billboard_stuff();

	return(&DFEngine);
}

void set_up_billboard_stuff()
{
	HANDLE find_handle;
	WIN32_FIND_DATAW find_file_data;

	wchar_t game_directory[MAX_PATH];
	wchar_t search_path[MAX_PATH];
	int path_size;

	//PrintLog->PrintSys("Setting up billboards.\n");

	GetCurrentDirectoryW(MAX_PATH,game_directory);
	path_size=wcslen(game_directory);

	wcscpy(search_path,game_directory);
	wcscpy(&search_path[path_size],L"\\billboards\\*.*");

	memset(&find_file_data,0,sizeof(find_file_data));
	find_handle=FindFirstFileW(search_path,&find_file_data);

	if(find_handle == INVALID_HANDLE_VALUE)
	{
		number_of_billboard_files=0;
	}
	else
	{
		while(FindNextFileW(find_handle,&find_file_data))
		{
			if(wcslen(find_file_data.cFileName)>3)
			{
				find_billboards_list.push_back(find_file_data.cFileName);
			}
		}
		number_of_billboard_files=find_billboards_list.size();
	}

	PrintLog->PrintSys("Found %i billboard files\n",number_of_billboard_files);

	FindClose(find_handle);
	return;
}


int	CDFObjectInstance::GetAbsoluteFilename(void *that, wchar_t * filenamepath_out, int param_3)
{
	wchar_t* default_ad_dir=L"\\data\\DFEngine\\cache\\data\\Default\\Default.tga";

	wchar_t game_directory[MAX_PATH];
	int path_size;

	//PrintLog->PrintSys("CDFObjectInstance::GetAbsoluteFilename\n");

	GetCurrentDirectoryW(MAX_PATH,game_directory);
	path_size=wcslen(game_directory);

	if(number_of_billboard_files == 0)
	{
		wcscpy(filenamepath_out,game_directory);
		wcscpy(&filenamepath_out[path_size],default_ad_dir);
		PrintLog->PrintSys("Billboard directory not found or empty. Using default billboard.\n");
		//PrintLog->PrintSys("CDFObjectInstance::GetAbsoluteFilename(%S)\n",filenamepath_out);
	}
	else
	{
		//PrintLog->PrintSys("Number of files: %i",number_of_billboard_files);
		wcscpy(filenamepath_out,game_directory);
		wcscpy(&filenamepath_out[path_size],L"\\billboards\\");
		wcscpy(&filenamepath_out[path_size+12],find_billboards_list[rand()%number_of_billboard_files].c_str());

		//PrintLog->PrintSys("CDFObjectInstance::GetAbsoluteFilename(%S)\n",filenamepath_out);
	}
	return 0;
}

int	CDFObjectInstance::UpdateOnEvent(void *that, int param_2, float *param_3)
{
	//PrintLog->PrintSys("CDFObjectInstance::UpdateOnEvent\n");
	return 0;
}

int	CDFObjectInstance::SetLocalBoundingBox(void *that, float *param_2, float *param_3)
{
	//PrintLog->PrintSys("CDFObjectInstance::SetLocalBoundingBox\n");
	return 0;
}

float* CDFObjectInstance::SetLocalLookAt(void *that, float *param_2)
{
	//PrintLog->PrintSys("CDFObjectInstance::SteLocalLookAt\n");
	return param_2;
}

int	CDFEngine::Start(void *param_1, int version, wchar_t **data_directory)
{
	//PrintLog->PrintSys("DFEngine::Start(%x, %S)\n", version, *data_directory);
	return 0;
	//return -1;
}

int CDFEngine::StartZone(void *param_1, char *ZoneName)
{
	///PrintLog->PrintSys("DFEngine::StartZone(%s)\n", ZoneName);
	return 0;
}

int	CDFEngine::CreateDFObject(void *param_1, char *ObjectIdent, CDFObjectInstance **param_3)
{
	//PrintLog->PrintSys("DFEngine::CreateDFObject(%s)\n", ObjectIdent);

	*param_3=&fake_CDFObject;
	return 0;
}

void CDFEngine::Update(void *param_1, float TimeSinceLastUpdate)
{
	//PrintLog->PrintSys("DFEngine::Update(%f)\n",TimeSinceLastUpdate);
	return;
}

void CDFEngine::SetCameraViewMatrix(void *param_1, float *pViewMatrix)
{
	//PrintLog->PrintSys("DFEngine::SetCameraViewMatrix(%f, %f, %f, %f)",pViewMatrix[0],pViewMatrix[1],pViewMatrix[2],pViewMatrix[3]);
	return;
}

void CDFEngine::SetCameraProjMatrix(void *param_1, float *pProjMatrix)
{
	//PrintLog->PrintSys("DFEngine::SetCameraProjMatrix(%f, %f, %f, %f)",pProjMatrix[0],pProjMatrix[1],pProjMatrix[2],pProjMatrix[3]);
	return;
}