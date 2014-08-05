-- Create frame for responding to game events
local f = CreateFrame( "Frame", "GuildChatAlert", UIParent );

-- Current player (toon-realm)
local currentPlayer = UnitName( "player" ).."-"..GetRealmName();

-- Handle event CHAT_MSG_GUILD
function f:CHAT_MSG_GUILD( event, ... )
	local _, sender = ...;

	if ( sender ~= currentPlayer ) then
		PlaySoundFile( "Interface\\AddOns\\GuildChatAlert\\Sounds\\snd-chat.mp3", "master" );
	end;
end;

-- Handle event CHAT_MSG_OFFICER
function f:CHAT_MSG_OFFICER( event, ... )
	local _, sender = ...;

	if ( sender ~= currentPlayer ) then
		PlaySoundFile( "Interface\\AddOns\\GuildChatAlert\\Sounds\\snd-officer.mp3", "master" );
	end;
end;

-- Generic event handler
local function OnEvent( self, event, ... )
	self[event]( self, event, ... );
end;

-- Setup event handler
f:SetScript( "OnEvent", OnEvent );

-- Register events to listen to
f:RegisterEvent( "CHAT_MSG_GUILD" );
f:RegisterEvent( "CHAT_MSG_OFFICER" );