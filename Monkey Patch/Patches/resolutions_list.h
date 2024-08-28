#pragma once

typedef unsigned int (__fastcall *hook_localization_type)(char *);

static int *resolution_width_list=(int *)0x00E8DF14;
static int *resolution_height_list=(int *)0x00E8DF4C;

unsigned int __fastcall hook_localization_strings(char *str);
void patch_localization_strings();

void list_resolutions();
void enumerate_resolutions();
void override_resolutions();