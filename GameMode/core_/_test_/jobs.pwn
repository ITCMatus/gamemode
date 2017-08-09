#include <a_samp>
#include <a_stream>


// id, (PICKUP x,y,z), Local,

public OnGameModeInit()
{
	return true;
}

stock CreateJob(id, local, float:x, float:y, float:z)
{
	CreateDynamicPickup(1581, 1, x,y,z, -1, -1, -1, STREAMER_PICKUP_SD, -1);
	
	return true;
}