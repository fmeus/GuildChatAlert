-- Create frame for responding to game events
local f = CreateFrame( "Frame", "GuildChatAlert", UIParent );

-- Gratz variants
local messages = { "gratz","Gratz","gz","Gz" };

-- Tracking variables
local lastTrigger, delayTime, totalTime, sendMessage = 0, 20, 0, false;

-- Was event caused by the current player
local function currentPlayerEvent( sender )
	return ( ( sender == UnitName( "player" ) ) or ( sender == UnitName( "player" ).."-"..GetRealmName() ) );
end;

-- Send gratz to guild chat after n seconds (determined by delayTime)
local function OnUpdate( self, elapsed )
	totalTime = totalTime + elapsed;

	if ( totalTime >= delayTime and sendMessage ) then
		sendMessage, totalTime = false, 0;
		local toss = random( 1, getn( messages ) );

		SendChatMessage( messages[toss], "GUILD" );
	end;
end;

-- Handle event CHAT_MSG_GUILD
function f:CHAT_MSG_GUILD( event, ... )
	local _, sender = ...;

	if ( not currentPlayerEvent( sender ) ) then
		PlaySoundFile( "Interface\\AddOns\\GuildChatAlert\\Sounds\\snd-chat.mp3", "master" );
	end;
end;

-- Handle event CHAT_MSG_OFFICER
function f:CHAT_MSG_OFFICER( event, ... )
	local _, sender = ...;

	if ( not currentPlayerEvent( sender ) ) then
		PlaySoundFile( "Interface\\AddOns\\GuildChatAlert\\Sounds\\snd-officer.mp3", "master" );
	end;
end;

-- Handle event CHAT_MSG_GUILD_ACHIEVEMENT
function f:CHAT_MSG_GUILD_ACHIEVEMENT( event, ... )
	local message, sender = ...;
	local interval = time() - lastTrigger;
	local playerAFK = UnitIsAFK( "player" ) or 0;

	if ( not currentPlayerEvent( sender ) ) then
		if ( interval >= 60 and playerAFK == 0 ) then
			totalTime = 0;
			sendMessage = true;
			lastTrigger = time();
		end;
		PlaySoundFile("Sound\\Spells\\AchievmentSound1.wav");
	end;
end;

-- Generic event handler
local function OnEvent( self, event, ... )
	self[event]( self, event, ... );
end;

-- Setup event handler
f:SetScript( "OnEvent", OnEvent );
f:SetScript( "OnUpdate", OnUpdate );

-- Register events to listen to
f:RegisterEvent( "CHAT_MSG_GUILD" );
f:RegisterEvent( "CHAT_MSG_OFFICER" );
f:RegisterEvent( "CHAT_MSG_GUILD_ACHIEVEMENT" );