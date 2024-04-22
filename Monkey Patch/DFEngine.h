#pragma once

class CDFEngine
{	
public:
	virtual int		Start(void *param_1, wchar_t *param_2, wchar_t *param_3){return -1;} // return fatal error code
	virtual void	Shutdown(void *param_1) {return;}
	virtual int		SetSoundSystem(void *param_1, int param_2, int param_3) {return 0;}
	virtual int		CreateDFObject(void *param_1, char *ObjectIdent, void *param_3) {return 0;}
	virtual int		RemoveDFObject(void *param_1, void *param_2) {return 0;}
	virtual int		DestroyAllDfObjects(void *param_1, int param_2) {return 0;}
	virtual int		RefreshCurrentCreatives(void *param_1, int param_2) {return 0;}
	virtual void	Update(void *param_1, float TimeSinceLastUpdate) {return;}
	virtual int		StartZone(void *param_1, char *ZoneName) {return 0;}
	virtual void	LeaveZone(void *param_1, char *ZoneName) {return;}
	virtual void	UpdateContentFromServerBlocking(void* param_1) {return;}
	virtual int		GetEngineParameter(void *param_1, char *pParamName, void *pReturnValue, void *param_4) {return 0;}
	virtual int		SetEngineParameter(void *param_1, char *pParamName, void *pParamValue) {return 0;}
	virtual void	SetCameraViewMatrix(void *param_1, float *pViewMatrix) {return;}
	virtual void	SetCameraProjMatrix(void *param_1, float *pProjMatrix) {return;}
	virtual void	SetNetworkDownloadLimit(void *param_1, int nRate) {return;}
	virtual void	SetNetworkUploadLimit(void *param_1, int nRate) {return;}
	virtual void	SetNetworkEnable(void *param_1, bool bEnable) {return;}
	virtual void*	dtor(void *param_1, bool bFreeMemory) {return param_1;}
};

extern "C" __declspec(dllimport) CDFEngine *CreateDFEngine(void);

