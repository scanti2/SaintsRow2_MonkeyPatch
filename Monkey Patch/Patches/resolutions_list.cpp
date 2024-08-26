#include "resolutions_list.h"
#include "../FileLogger.h"

void list_resolutions()
{
	for(int i=0;i<14;i++)
	{
		PrintLog->PrintSys("Resolution option [%i] = %i X %i\n",i,resolution_width_list[i], resolution_height_list[i]);
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

		// doesn't check for all errors but should be good enough.

		width=strtol(current_line, &end_of_num, 10);
		
		while(!isdigit(*end_of_num))
		{
			end_of_num++;
		}

		height=strtol(end_of_num, &end_of_num, 10);
		
		resolution_width_list[i]=width;
		resolution_height_list[i]=height;

		PrintLog->PrintSys("resolutions.txt line [%i] = %i X %i \n", i, width, height);
	}
	fclose(resolutions_file);
}

		
