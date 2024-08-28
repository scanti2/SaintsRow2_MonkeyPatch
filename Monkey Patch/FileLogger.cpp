#include "FileLogger.h"
#include "stdafx.h"

FileLogger *PrintLog;

const char *FileLogger::LevelList[5] = 
{
	"FTERR",
	"ERR",
	"WARN",
	"INFO",
	"SYS"
};

const int FileLogger::LL_FTERR=0;
const int FileLogger::LL_ERR=1;
const int FileLogger::LL_WARN=2;
const int FileLogger::LL_INFO=3;
const int FileLogger::LL_SYS=4;

FileLogger::FileLogger()
{
	Init("log.txt");
	return;
}

FileLogger::FileLogger(char *FileName)
{
	Init(FileName);
	return;
}

void FileLogger::Init(char *FileName)
{
	log_handle=fopen(FileName,"w");
	if (IsOK())
	{
		SYSTEMTIME StartTime;
		GetLocalTime(&StartTime);
		char DateBuffer[255];
		GetDateFormatA(LOCALE_USER_DEFAULT,DATE_LONGDATE,&StartTime,NULL,DateBuffer,255);
		fprintf(log_handle,"Start : %s %02u:%02u:%02u\n",DateBuffer,StartTime.wHour,StartTime.wMinute,StartTime.wSecond);
		StartTick=GetTickCount();
		LogLevel=2;
	}
	return;
}

bool FileLogger::PrintSys(char *message,...) const
{
	va_list args;
    va_start(args, message);
	
	if (IsOK())
		fprintf(log_handle,"%12u\t%s\t",GetTickCount()-StartTick,LevelList[LL_SYS]);
	Print(message, args);

// If we are debugging we could be crashing, so make sure the log file data is written so soon as possible. Otherwise
// important debugging info could get lost in the crash.

#ifdef _DEBUG
	fflush(log_handle);
#endif

    va_end(args);

	return(IsOK());
}

bool FileLogger::PrintInfo(char *message,...) const
{
	va_list args;
    va_start(args, message);
	
	PrintLevel(LL_INFO,message,args);

    va_end(args);

	return(IsOK());
}

bool FileLogger::PrintWarn(char *message,...) const
{
	va_list args;
    va_start(args, message);
	
	PrintLevel(LL_WARN,message,args);

    va_end(args);

	return(IsOK());
}

bool FileLogger::PrintError(char *message,...) const
{
	va_list args;
    va_start(args, message);
	
	PrintLevel(LL_ERR,message,args);

    va_end(args);

	return(IsOK());
}

bool FileLogger::PrintFatal(char *message,...) const
{
	va_list args;
    va_start(args, message);
	
	PrintLevel(LL_FTERR,message,args);
	fflush(log_handle);

    va_end(args);

	return(IsOK());
}

bool FileLogger::PrintLevel(int Level,char *message,va_list vars) const
{	
	if (IsOK() && Level<=LogLevel)
	{
		fprintf(log_handle,"%12u\t%s\t",GetTickCount()-StartTick,LevelList[Level]);
		Print(message, vars);
	}

// If we are debugging we could be crashing, so make sure the log file data is written so soon as possible. Otherwise
// important debugging info could get lost in the crash.

//#ifdef _DEBUG
	fflush(log_handle);
//#endif

	return(IsOK());
}

bool FileLogger::PrintMore(char *message, ...) const
{	
	va_list args;
    va_start(args, message);

	if (IsOK())
	{
		vfprintf(log_handle,message, args);
	}

	va_end(args);

// If we are debugging we could be crashing, so make sure the log file data is written so soon as possible. Otherwise
// important debugging info could get lost in the crash.

//#ifdef _DEBUG
	fflush(log_handle);
//#endif

	return(IsOK());
}

bool FileLogger::Print(char *message,va_list vars) const
{
	if(IsOK())
	{
		vfprintf(log_handle,message,vars);
		return(true);
	}
	return(false);
}


void FileLogger::SetLogLevel(int Level)
{
	LogLevel=Level;
	return;
}

FileLogger::~FileLogger()
{
	if(IsOK())
		fclose(log_handle);
	return;
}