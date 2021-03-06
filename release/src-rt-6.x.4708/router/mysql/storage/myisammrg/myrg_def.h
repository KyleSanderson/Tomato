/* Copyright (c) 2000, 2001, 2003, 2005-2007 MySQL AB

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA */

/* This file is included by all myisam-merge files */

#ifndef N_MAXKEY
#include "../myisam/myisamdef.h"
#endif

#include "myisammrg.h"

extern LIST *myrg_open_list;

#ifdef THREAD
extern pthread_mutex_t THR_LOCK_open;
#endif

int _myrg_init_queue(MYRG_INFO *info,int inx,enum ha_rkey_function search_flag);
int _myrg_mi_read_record(MI_INFO *info, uchar *buf);
#ifdef __cplusplus
extern "C" 
#endif
void myrg_print_wrong_table(const char *table_name);
