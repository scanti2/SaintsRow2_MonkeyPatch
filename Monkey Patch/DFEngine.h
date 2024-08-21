#pragma once

class CDFObjectInstance
{
public:
	virtual int		GetAbsoluteFilename(void *that, LPCWCH filnamepath_out, int param_3);
	virtual bool	IsCreativeChanged(void *that);
	virtual int		UpdateOnEvent(void *that, int param_2, float *param_3);
	virtual int		CopyTexture(void *that, int param_2, int param_3, int param_4, int param_5, int param_6, int param_7);
	virtual int		GetTextureLevelCount(void *that);
	virtual int		GetTextureInfo(void *that, int param_2, int param_3);
	virtual int		GetCustomData(void *that, void *param_2, void *param_3);
	virtual int		GetCreativeInfo(void *that, int param_2);
	virtual int		GetTrackingInfo(void *that, int param_2);
	virtual int		PerformAction(void *that, int param_2, int param_3);
	virtual int		GetId(void *that);
	virtual void *	GetClassAtOffset04(void *that);
	virtual int		CallClassMethod10AtOffset08(void *that);
	virtual int		CallClassMethod11AtOffset08(void *that);
	virtual void *	CreateInstance(void *that);
	virtual int		ReleaseCurrentCreative(void *that);
	virtual int		RefreshCurrentCreative(void *that);
	virtual int		SetProperty(void *that, int param_2, int param_3);
	virtual int		GetProperty(void *that, int param_2, int param_3);
	virtual int		SetLocalBoundingBox(void *that, float *param_2, float *param_3);
	virtual int		SetLocalLookAt(void *that, float *param_2);
	virtual void	SetWorldMatrix(void *that, float *world_matrix);
	virtual int		GetContentDeliveryMode(void *that);
	virtual void *	dtor(void *that, char memory_flags);

	void *class_offest_04;
	void *class_offset_08;
};



class CDFEngine
{	
public:
	virtual int		Start(void *param_1, int version, wchar_t **data_directory); // return fatal error code
	virtual void	Shutdown(void *param_1) {return;}
	virtual int		SetSoundSystem(void *param_1, int param_2, int param_3) {return 0;}
	virtual int		CreateDFObject(void *param_1, char *ObjectIdent, CDFObjectInstance *param_3);
	virtual int		RemoveDFObject(void *param_1, void *param_2) {return 0;}
	virtual int		DestroyAllDfObjects(void *param_1, int param_2) {return 0;}
	virtual int		RefreshCurrentCreatives(void *param_1, int param_2) {return 0;}
	virtual void	Update(void *param_1, float TimeSinceLastUpdate);
	virtual int		StartZone(void *param_1, char *ZoneName);
	virtual void	LeaveZone(void *param_1, char *ZoneName) {return;}
	virtual void	UpdateContentFromServerBlocking(void* param_1) {return;}
	virtual int		GetEngineParameter(void *param_1, char *pParamName, void *pReturnValue, void *param_4) {return 0;}
	virtual int		SetEngineParameter(void *param_1, char *pParamName, void *pParamValue) {return 0;}
	virtual void	SetCameraViewMatrix(void *param_1, float *pViewMatrix);
	virtual void	SetCameraProjMatrix(void *param_1, float *pProjMatrix);
	virtual void	SetNetworkDownloadLimit(void *param_1, int nRate) {return;}
	virtual void	SetNetworkUploadLimit(void *param_1, int nRate) {return;}
	virtual void	SetNetworkEnable(void *param_1, bool bEnable) {return;}
	virtual void*	dtor(void *param_1, bool bFreeMemory) {return param_1;}
};

extern "C" __declspec(dllimport) CDFEngine *CreateDFEngine(void);

