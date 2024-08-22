// Blank DFEngine.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "DFEngine.h"
#include "FileLogger.h"
#include "SafeWrite.h"
#include "MainHooks.h"
#include "iat_functions.h"

static CDFEngine DFEngine;
static CDFObjectInstance fake_CDFObject;

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

	return(&DFEngine);
}

int	CDFObjectInstance::GetAbsoluteFilename(void *that, wchar_t * filenamepath_out, int param_3)
{
	static wchar_t* test_ad_directory=L"C:\\Games\\GOG\\Saints Row 2\\data\\DFEngine\\cache\\data\\Default\\Default.tga";
	wchar_t* test_ad_dir=L"\\data\\DFEngine\\cache\\data\\Default\\Default.tga";

	wchar_t ad_directory[260];
	int path_size;

	GetCurrentDirectoryW(260,ad_directory);
	path_size=wcslen(ad_directory);
	
	//PrintLog->PrintSys("CDFObjectInstance::GetAbsoluteFilename\n");
	wcscpy(filenamepath_out,ad_directory);
	wcscpy(&filenamepath_out[path_size],test_ad_dir);
	PrintLog->PrintSys("CDFObjectInstance::GetAbsoluteFilename(%S)\n",filenamepath_out);
	return 0;
}

int	CDFObjectInstance::UpdateOnEvent(void *that, int param_2, float *param_3)
{
	//PrintLog->PrintSys("CDFObjectInstance::UpdateOnEvent\n");
	return 0;
}

int	CDFObjectInstance::SetLocalBoundingBox(void *that, float *param_2, float *param_3)
{
	PrintLog->PrintSys("CDFObjectInstance::SetLocalBoundingBox\n");
	return 0;
}

float* CDFObjectInstance::SetLocalLookAt(void *that, float *param_2)
{
	PrintLog->PrintSys("CDFObjectInstance::SteLocalLookAt\n");
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
	PrintLog->PrintSys("DFEngine::StartZone(%s)\n", ZoneName);
	return 0;
}

int	CDFEngine::CreateDFObject(void *param_1, char *ObjectIdent, CDFObjectInstance **param_3)
{
	PrintLog->PrintSys("DFEngine::CreateDFObject(%s)\n", ObjectIdent);

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