#pragma once
#include "../DFEngine.h"

static int override_width=800;
static int override_height=600;
extern bool override_resolution;

typedef unsigned int (__fastcall *hook_localization_type)(char *);

static int *resolution_width_list=(int *)offset_addr(0x00E8DF14);
static int *resolution_height_list=(int *)offset_addr(0x00E8DF4C);

static int *revert_res_width=(int*)offset_addr(0x022FD84C);
static int *revert_res_height=(int*)offset_addr(0x022FD850);

typedef bool(__cdecl *hook_into_override_resolutions)();


unsigned int __fastcall hook_localization_strings(char *str);
void patch_localization_strings();

void list_resolutions();
void enumerate_resolutions();
void override_resolutions();

bool __cdecl hook_override_resolution();
void patch_override_resolution();