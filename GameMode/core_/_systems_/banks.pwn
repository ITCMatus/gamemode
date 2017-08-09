stock AddBank(SID,Float:IntX,Float:IntY,Float:IntZ,ExitZRot,ExitID,Local)
{
	if(InteriorCount+1 < MAX_BANK)
	{
		InteriorCount ++;
		InteriorInfo[InteriorCount][Int_SID]      = SID;
		InteriorInfo[InteriorCount][Exit_ID]      = ExitID;
		InteriorInfo[InteriorCount][Exit_X]       = IntX-floatsin(ExitZRot,degrees)*2.5;
		InteriorInfo[InteriorCount][Exit_Y]       = IntY+floatcos(ExitZRot,degrees)*2.5;
		InteriorInfo[InteriorCount][Exit_Z]       = IntZ-0.2;
		InteriorInfo[InteriorCount][Exit_ZRot]    = ExitZRot;
		InteriorInfo[InteriorCount][Int_Lokalita] = Local;
		InteriorInfo[InteriorCount][Int_Pick]     = CreatePickup(19902,1,IntX,IntY,IntZ-0.5);
	}
	else print("| System | - Maximálne možstvo vytvoreních bánk");
	return true;
}
// Pickup, Dialog, 3DText Label 