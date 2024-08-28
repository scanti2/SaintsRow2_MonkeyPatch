#include "resolutions_list.h"
#include "../FileLogger.h"
#include "../SafeWrite.h"

unsigned int __fastcall hook_localization_strings(char *str)
{
	 hook_localization_type orig_localization=(hook_localization_type)0x00BDC9B0;
	 if(isdigit(*str))
	 {
		 PrintLog->PrintSys("Localization string: %s\n",str);
	 }
	 return(orig_localization(str));
}


void patch_localization_strings()
{
	WriteRelCall(0x007F4BC9, (UInt32)&hook_localization_strings);
}


void list_resolutions()
{
	for(int i=0;i<14;i++)
	{
		PrintLog->PrintSys("Resolution option [%i] = %i X %i\n",i,resolution_width_list[i], resolution_height_list[i]);
	}
}

void enumerate_resolutions()
{
	DEVMODE dm = { 0 };
	DISPLAY_DEVICE dd = { 0 };
	DWORD last_width=0, last_height=0;

	bool display_active, display_mirror, display_primary, display_removable;

	dm.dmSize = sizeof(dm);
	dd.cb = sizeof(dd);

	for ( int iDevNum = 0 ; EnumDisplayDevices(NULL, iDevNum, &dd, 0) !=0; iDevNum++ )
	{
		if(!(dd.StateFlags&DISPLAY_DEVICE_ACTIVE))
			continue;

		PrintLog->PrintSys("Device %i: Name = %S, String = %S, Flags = ", iDevNum, dd.DeviceName, dd.DeviceString);
		if(dd.StateFlags&DISPLAY_DEVICE_ACTIVE)
			PrintLog->PrintMore("active ");
		if(dd.StateFlags&DISPLAY_DEVICE_MIRRORING_DRIVER)
			PrintLog->PrintMore("mirrored ");
		if(dd.StateFlags&DISPLAY_DEVICE_PRIMARY_DEVICE)
			PrintLog->PrintMore("primary ");
		PrintLog->PrintMore("\n");
	

		for( int iModeNum = 0; EnumDisplaySettings( dd.DeviceName, iModeNum, &dm ) != 0; iModeNum++ )
		{
			if (last_width==dm.dmPelsWidth && last_height==dm.dmPelsHeight)
				continue;

			PrintLog->PrintSys("Mode %i = %i x %i (%i bpp) %i Hz\n",iModeNum, dm.dmPelsWidth, dm.dmPelsHeight, dm.dmBitsPerPel, dm.dmDisplayFrequency);
			
			last_width=dm.dmPelsWidth;
			last_height=dm.dmPelsHeight;
		}
	}
}

void override_resolutions()
{
	FILE *resolutions_file;
	char current_line[64];
	int width, height;
	char *end_of_num;

	resolutions_file=fopen("resolutions.txt","rt");
	
	if(resolutions_file==NULL)
	{
		PrintLog->PrintWarn("Reading the resolutions.txt file failed. Skipping.\n");
		return;
	}

	for (int i=0; i<14; i++)
	{
		if(fgets(current_line, sizeof(current_line), resolutions_file)==NULL)
		{
			break;
		}

		width=strtol(current_line, &end_of_num, 10);

		while(*end_of_num && !isdigit(*end_of_num))
		{
			end_of_num++;
		}

		height=strtol(end_of_num, &end_of_num, 10);

		// As neither width or height can be 0 and strtol returns 0 when it can't convert a number use this for error checking
		if(width && height)
		{
			
			resolution_width_list[i]=width;
			resolution_height_list[i]=height;	

			PrintLog->PrintSys("resolutions.txt line [%i] = %i X %i \n", i, width, height);
		}
		else
		{
			PrintLog->PrintSys("error parsing line %i: %s in resolutions.txt",i,current_line);
		}
	}
	fclose(resolutions_file);
}

		
