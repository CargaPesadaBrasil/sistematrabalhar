#include <a_samp>
#include <zcmd>
#include <sscanf2>

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("           Sistema /trabalhar           ");
	print("         Não retire os créditos         ");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

enum pCarga
{
    CargaID,
    Carregamento,
    Descarregamento,
    PartedoTrabalho,
    VeiculoID,
    TrailerID,
    TempoCargaDescarga,
    bool:pTrabalhando,
    pPontos,
    pDinheiro
}

new CargaInfo[MAX_PLAYERS][pCarga];

#define CargaFluido   123
#define CargaMinerio  124
#define CargaFechada  125

enum Local_CargaDescarga
{
	NomedoLocal[50],
	Float:LocX,
	Float:LocY,
	Float:LocZ
}


new LocalCargaDescarga[][Local_CargaDescarga] =
{
	// Local, FloatX, FloatY, FloatZ
	{"Dummy location", 0.0, 0.0, 0.0},
	{"Loja de Bebidas de Los Santos", 2337.0, -1371.1, 24.0}, // Local 1
	{"Rodriguez Ferro e Aço", 2443.4, -1426.1, 24.0}, // Local 2
	{"Lava Jato de Los Santos", 2511.4, -1468.6, 24.0}, // Local 3
	{"Estádio de Los Santos", 2802.0, -1818.2, 9.9} // Local 4
};

enum TLoad
{
	LoadName[50],
	Float:PayPerUnit,
	PCV_Required,
	FromLocations[30],
	ToLocations[30]
}

new ALoads[][TLoad] =
{
	// Nome da Carga, Preço por metro, Veículo que precisa, Local que pega, Local que entrega
	{"Dummy", 0.00, 0, {0}, {0}},

	// Cargas de Trailer com Minério
	{"Leite", 1.00, CargaFluido, {1}, {2, 3, 4}}, // CargaID 1

	// Cargas de Trailer de Flúidos
	{"Cascalho", 1.00, CargaMinerio,  {1}, {2, 3, 4}}, // CargaID 2

	// Cargas de Trailer Fechado
	{"Comida enlatada", 1.00, CargaFechada,  {1}, {2, 3, 4}},
 	{"Cerveja", 1.00, CargaFechada,  {1}, {2, 3, 4}}
};

stock Product_GetList(PCV_Needed, &NumProducts)
{
	new ListadeProdutos[50];
	for (new i; i < sizeof(ALoads); i++)
	{
		if (NumProducts < 50)
		{
			if (ALoads[i][PCV_Required] == PCV_Needed)
			{
				ListadeProdutos[NumProducts] = i;
				NumProducts++;
			}
		}
	}
	return ListadeProdutos;
}

#define TrailerFluidos 584
#define TrailerFechado1 435
#define TrailerFechado2 591
#define TrailerMinerio 450

#define VeiculoRoadTrain 515
#define VeiculoLineRunner 403
#define VeiculoTanker 514

#define DialogoCaminhaoEscolha 996
#define DialogoCaminhaoCarga 997
#define DialogoCaminhaoCarregamento 998
#define DialogoCaminhaoDescarregamento 999

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    Caminhoneiro_EntrouCP(playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DialogoCaminhaoCarga: Dialogo_CaminhaoCarga(playerid, response, listitem);
    	case DialogoCaminhaoCarregamento: Dialogo_CaminhaoCarregamento(playerid, response, listitem);
    	case DialogoCaminhaoDescarregamento: Dialogo_CaminhaoDescarregamento(playerid, response, listitem);
 	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:trabalhar(playerid, params[])
{
	if(CargaInfo[playerid][pTrabalhando] == true)
	    return SendClientMessage(playerid, -1, "[ERRO] Você já está trabalhando.");

    if(GetPlayerVehicleSeat(playerid) != 0)
	    return SendClientMessage(playerid, -1, "[ERRO] Você precisa ser o motorista para começar a trabalhar.");

    new ListadeProdutos[50], NumProducts, TotalLoadList[1000];
    switch (GetVehicleModel(GetPlayerVehicleID(playerid))) // Check the vehicle-model of the player to decide which loads the player can carry
	{
		case VeiculoRoadTrain, VeiculoLineRunner, VeiculoTanker: // If the player's vehicle is a "LineRunner", "Tanker" or "RoadTrain"
		{
			switch (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid)))) // Select the loads based on the trailer model of the player
			{
				case TrailerFechado1, TrailerFechado2: // A cargo-trailer is attached
					ListadeProdutos = Product_GetList(CargaFechada, NumProducts); // Build a list of products defined for truckers with a cargo-trailer
				case TrailerMinerio:
				    ListadeProdutos = Product_GetList(CargaMinerio, NumProducts);
				case TrailerFluidos:
				    ListadeProdutos = Product_GetList(CargaFluido, NumProducts);
				case 0:
				    SendClientMessage(playerid, -1, "[ERRO] Você precisa de um trailer para continuar!");
			}
		}
		case 482, 499, 440, 414, 456:
		    ListadeProdutos = Product_GetList(CargaFechada, NumProducts);
		case 0:
		    SendClientMessage(playerid, -1, "[ERRO] Você precisa estar em um veículo para começar a trabalhar!");
	}
	for (new i; i < NumProducts; i++)
	format(TotalLoadList, 1000, "%s%s\n", TotalLoadList, ALoads[ListadeProdutos[i]][LoadName]);
	ShowPlayerDialog(playerid, DialogoCaminhaoCarga, DIALOG_STYLE_LIST, "Selecione sua carga:", TotalLoadList, "Selecionar", "Sair");
	return 1;
}

Dialogo_CaminhaoCarga(playerid, response, listitem)
{
    // Setup local variables
	new TotalStartLocList[1000], ListadeProdutos[50], NumProducts, ProductID, LocID;

	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

	// First get the list of products again, so we can retrieve the selected load from it
	switch (GetVehicleModel(GetPlayerVehicleID(playerid))) // Check the vehicle-model of the player
	{
		case VeiculoRoadTrain, VeiculoLineRunner, VeiculoTanker: // If the player's vehicle is a "LineRunner", "Tanker" or "RoadTrain"
		{
			switch (GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid)))) // Select the loads based on the trailer model of the player
			{
				case TrailerFechado1, TrailerFechado2: // A cargo-trailer is attached
					ListadeProdutos = Product_GetList(CargaFechada, NumProducts); // Build a list of products defined for truckers with a cargo-trailer}
				case TrailerMinerio:
					ListadeProdutos = Product_GetList(CargaMinerio, NumProducts);
				case TrailerFluidos:
				    ListadeProdutos = Product_GetList(CargaFluido, NumProducts);
			}
		}
		case 482, 499, 440, 414, 456:
		    ListadeProdutos = Product_GetList(CargaFechada, NumProducts);
	}

	// Store the selected LoadID in the player's account
	CargaInfo[playerid][CargaID] = ListadeProdutos[listitem];
	ProductID = CargaInfo[playerid][CargaID];

	// Build a list of start-locations for this product
	for (new i; i < 30; i++)
	{
	    // Get the location-id
	    LocID = ALoads[ProductID][FromLocations][i];
	    // Check if it a valid location-id (not 0)
	    if (LocID != 0)
			format(TotalStartLocList, 1000, "%s%s\n", TotalStartLocList, LocalCargaDescarga[LocID][NomedoLocal]); // Add the location-name to the list
		else
		    break; // As soon as an invalid location-id has been found, stop adding entries to the location-list
	}

	// Ask the player to choose a start-location
	ShowPlayerDialog(playerid, DialogoCaminhaoCarregamento, DIALOG_STYLE_LIST, "Selecione o local de carregamento", TotalStartLocList, "Selecionar", "Cancelar"); // Let the player choose a starting location

	return 1;
}

Dialogo_CaminhaoCarregamento(playerid, response, listitem)
{
    // Setup local variables
	new ProductID, LocID, TotalEndLocList[1000];

	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;
	ProductID = CargaInfo[playerid][CargaID];
	// Store the chosen start-location in the player's account
	CargaInfo[playerid][Carregamento] = ALoads[ProductID][FromLocations][listitem];

	// Build a list of end-locations for this product
	for (new i; i < 30; i++)
	{
	    // Get the location-id
	    LocID = ALoads[ProductID][ToLocations][i];
	    if (LocID != 0)
			format(TotalEndLocList, 1000, "%s%s\n", TotalEndLocList, LocalCargaDescarga[LocID][NomedoLocal]); // Add the location-name to the list
		else
		    break; // As soon as an invalid location-id has been found, stop adding entries to the location-list
	}

	// Ask the player to choose an end-location
	ShowPlayerDialog(playerid, DialogoCaminhaoDescarregamento, DIALOG_STYLE_LIST, "Selecione o local de descarregamento", TotalEndLocList, "Selecionar", "Cancelar"); // Let the player choose a endlocation

	return 1;
}

Dialogo_CaminhaoDescarregamento(playerid, response, listitem)
{
    // Setup local variables
	new loadName[50], startlocName[50], endlocName[50], LoadMsg[128], Float:x3, Float:y3, Float:z3, ProductID;

	// Just close the dialog if the player clicked "Cancel"
	if(!response) return 1;

	// Get the LoadID that's stored in the player's account
	ProductID = CargaInfo[playerid][CargaID];
	// Store the chosen end-location in the player's account
	CargaInfo[playerid][Descarregamento] = ALoads[ProductID][ToLocations][listitem];

    // Get the names for the load, startlocation and endlocation
	format(loadName, 50, "%s", ALoads[ProductID][LoadName]);
	format(startlocName, 50, "%s", LocalCargaDescarga[CargaInfo[playerid][Carregamento]][NomedoLocal]);
	format(endlocName, 50, "%s", LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][NomedoLocal]);

	// Job has started
	CargaInfo[playerid][pTrabalhando] = true;
	// Store the vehicleID (required to be able to check if the player left his vehicle)
	CargaInfo[playerid][VeiculoID] = GetPlayerVehicleID(playerid);
	// Store the trailerID (required to be able to check if the player lost his trailer)
	CargaInfo[playerid][TrailerID] = GetVehicleTrailer(GetPlayerVehicleID(playerid));
	// Set jobstep to 1 (going to load the goods)
	CargaInfo[playerid][PartedoTrabalho] = 1;
	// Grab the x, y, z positions for the first location
	x3 = LocalCargaDescarga[CargaInfo[playerid][Carregamento]][LocX];
	y3 = LocalCargaDescarga[CargaInfo[playerid][Carregamento]][LocY];
	z3 = LocalCargaDescarga[CargaInfo[playerid][Carregamento]][LocZ];
	// Create a checkpoint where the player should load the goods
	SetPlayerCheckpoint(playerid, x3, y3, z3, 7);
	format(LoadMsg, 128, "Você está carregando %s de %s para %s", loadName, startlocName, endlocName);
	SendClientMessage(playerid, 0xFFFFFFFF, LoadMsg);

	return 1;
}

Caminhoneiro_EntrouCP(playerid)
{
	if (GetPlayerVehicleID(playerid) != CargaInfo[playerid][VeiculoID])
	    return SendClientMessage(playerid, -1, "[ERRO] Você precisa estar em um caminhão para carregar seu trailer!");
	if (CargaInfo[playerid][TrailerID] != GetVehicleTrailer(GetPlayerVehicleID(playerid)))
		return SendClientMessage(playerid, -1, "[ERRO] Você precisa de um trailer para continuar o trabalho!");

    switch (CargaInfo[playerid][PartedoTrabalho])
    {
		case 1:
			SendClientMessage(playerid, -1, "Carregando seu caminhão, por favor, aguarde!");
		case 2:
		    SendClientMessage(playerid, -1, "Descarregando seu caminhão, por favor, aguarde!");
	}
	TogglePlayerControllable(playerid, 0);
	CargaInfo[playerid][TempoCargaDescarga] = SetTimerEx("Caminhoneiro_CarregarDesc", 5000, false, "d" , playerid);
	return 1;
}

forward Caminhoneiro_CarregarDesc(playerid);
public Caminhoneiro_CarregarDesc(playerid)
{
	switch (CargaInfo[playerid][PartedoTrabalho])
	{
	    case 1:
		{
			new StartLoc[50], EndLoc[50], Load[50], Float:x, Float:y, Float:z, UnloadMsg[100];
			// Set JobStep to 2 (unloading goods)
			CargaInfo[playerid][PartedoTrabalho] = 2;
			// Delete the loading-checkpoint
			DisablePlayerCheckpoint(playerid);
			// Get the startlocation, endlocation and the load texts
			format(StartLoc, 50, LocalCargaDescarga[CargaInfo[playerid][Carregamento]][NomedoLocal]);
			format(EndLoc, 50, LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][NomedoLocal]);
			format(Load, 50, ALoads[CargaInfo[playerid][CargaID]][LoadName]);
			x = LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][LocX];
			y = LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][LocY];
			z = LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][LocZ];
			// Create a checkpoint where the player should unload the goods
			SetPlayerCheckpoint(playerid, x, y, z, 7);
			TogglePlayerControllable(playerid, 1);
			format(UnloadMsg, 100, "Leve a carga de %s até %s.", Load, EndLoc);
			SendClientMessage(playerid, 0xFFFFFFFF, UnloadMsg);
		}
		case 2: // Player is delivering his goods
		{
		    // Setup local variables
			new StartLoc[50], EndLoc[50], Load[50], Msg1[128], Name[24];

			// Get the player name
			GetPlayerName(playerid, Name, sizeof(Name));
			// Get the startlocation, endlocation and the load texts
			format(StartLoc, 50, LocalCargaDescarga[CargaInfo[playerid][Carregamento]][NomedoLocal]);
			format(EndLoc, 50, LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][NomedoLocal]);
			format(Load, 50, ALoads[CargaInfo[playerid][CargaID]][LoadName]);
			format(Msg1, 128, "Caminhoneiro %s entregou %s de %s para %s.", Name, Load, StartLoc, EndLoc);
			SendClientMessageToAll(0xFFFFFFFF, Msg1);
			new Float:x1, Float:y1, Float:x2, Float:y2, Float:Distance, Message[128], Payment;
			// Grab the x, y, z positions for the first location (to load the goods)
			x1 = LocalCargaDescarga[CargaInfo[playerid][Carregamento]][LocX];
			y1 = LocalCargaDescarga[CargaInfo[playerid][Carregamento]][LocY];
			// Grab the x, y, z positions for the second location (to unload the goods)
			x2 = LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][LocX];
			y2 = LocalCargaDescarga[CargaInfo[playerid][Descarregamento]][LocY];
			// Calculate the distance between both points
			Distance = floatsqroot(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));

			// Calculate the payment for the player
			Payment = floatround((Distance * ALoads[CargaInfo[playerid][CargaID]][PayPerUnit]), floatround_floor);
			RewardPlayer(playerid, Payment, 0);
			// Send a message to let the player know he finished his mission and got paid
			format(Message, 128, "Você finalizou a entrega e ganhou R$%i.", Payment);
			SendClientMessage(playerid, 0xFFFFFFFF, Message);
			TogglePlayerControllable(playerid, 1);
			if (Distance > 3000.0)
				RewardPlayer(playerid, 0, 2); // Distance is larger than 3000 units, so add 2 points
			else
				RewardPlayer(playerid, 0, 1); // Distance is less than 3000 units, so add 1 point
			Caminhoneiro_AcabouTrabalho(playerid);
		}
	}
	return 1;
}
RewardPlayer(playerid, dinheiro, pontos)
{
	CargaInfo[playerid][pDinheiro] = CargaInfo[playerid][pDinheiro] + dinheiro;
	CargaInfo[playerid][pPontos] = CargaInfo[playerid][pPontos] + pontos;
	GivePlayerMoney(playerid, dinheiro);
	SetPlayerScore(playerid, CargaInfo[playerid][pPontos]);
}

Caminhoneiro_AcabouTrabalho(playerid)
{
	if (CargaInfo[playerid][pTrabalhando] == true)
	{
		CargaInfo[playerid][pTrabalhando] = false;
		CargaInfo[playerid][PartedoTrabalho] = 0;
		CargaInfo[playerid][VeiculoID] = 0;
		CargaInfo[playerid][TrailerID] = 0;
		CargaInfo[playerid][CargaID] = 0;
		CargaInfo[playerid][Carregamento] = 0;
		CargaInfo[playerid][Descarregamento] = 0;
		DisablePlayerCheckpoint(playerid);
		KillTimer(CargaInfo[playerid][TempoCargaDescarga]);
	}

	return 1;
}
