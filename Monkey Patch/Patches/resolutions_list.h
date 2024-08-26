#pragma once

static int *resolution_width_list=(int *)0x00E8DF14;
static int *resolution_height_list=(int *)0x00E8DF4C;

void list_resolutions();
void override_resolutions();