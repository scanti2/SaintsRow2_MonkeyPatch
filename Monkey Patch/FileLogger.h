#pragma once

#include "stdafx.h"

class FileLogger
{
public:
	FileLogger();
	FileLogger(char *FileName);
	~FileLogger();
	bool PrintSys(char *message,...) const;
	bool PrintInfo(char *message,...) const;
	bool PrintWarn(char *message,...) const;
	bool PrintError(char *message,...) const;
	bool PrintFatal(char *message,...) const;
	void SetLogLevel(int Level);
	int GetLogLevel() const
	{
		return(LogLevel);
	}

	

private:
	void Init(char *FileName);
	bool Print(char *message,va_list vars) const;
	bool PrintLevel(int Level,char *message,va_list vars) const;
	bool IsOK() const
	{
		return(log_handle!=0);
	}

	static const int LL_FTERR;
	static const int LL_ERR;
	static const int LL_WARN;
	static const int LL_INFO;
	static const int  LL_SYS;
	
	FILE *log_handle;
	unsigned int StartTick;
	int LogLevel;
	const static char *LevelList[5];
};

extern FileLogger *PrintLog;