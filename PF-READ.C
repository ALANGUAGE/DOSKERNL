FRESULT pf_read (
	void* buff,		// Pointer to the read buffer (NULL:Forward to stream)
	UINT btr,		// Number of bytes to read
	UINT* br		// Pointer to number of bytes read )
{	DRESULT dr;
	CLUST clst;
	DWORD sect, remain;
	UINT rcnt;
	BYTE cs, *rbuff = buff;
	FATFS *fs = FatFs;
	
	*br = 0;
	if (!fs) return FR_NOT_ENABLED;		//Check file system
	if (!(fs->flag & FA_OPENED)) return FR_NOT_OPENED;	// Check if opened

	remain = fs->fsize - fs->fptr;
	if (btr > remain) btr = (UINT)remain;//Truncate btr by remaining bytes

	while (btr)	{						//Repeat until all data transferred
		if ((fs->fptr % 512) == 0) {	//On the sector boundary? */
			cs = (BYTE)(fs->fptr / 512 & (fs->csize - 1));//Sect off in clust
			if (!cs) {					//On the cluster boundary?
				if (fs->fptr == 0) {	//On the top of the file?
					clst = fs->org_clust;
				} else {
					clst = get_fat(fs->curr_clust);
				}
				if (clst <= 1) ABORT(FR_DISK_ERR);
				fs->curr_clust = clst;	//Update current cluster
			}
			sect = clust2sect(fs->curr_clust);//Get current sector
			if (!sect) ABORT(FR_DISK_ERR);
			fs->dsect = sect + cs;
		}
		rcnt = 512 - (UINT)fs->fptr % 512;//partial sector data from sect buf
		if (rcnt > btr) rcnt = btr;
		dr = disk_readp(rbuff, fs->dsect, (UINT)fs->fptr % 512, rcnt);
		if (dr) ABORT(FR_DISK_ERR);
		fs->fptr += rcnt;				//Advances file read pointer
		btr -= rcnt; *br += rcnt;		//Update read counter
		if (rbuff) rbuff += rcnt;		//Advances the data pointer
	}

	return FR_OK;
}
