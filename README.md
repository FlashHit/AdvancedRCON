# Advanced RCON

AdvancedRCON in first place provides a bunch of RCON Events and Commands that can be used to create new RCON plugins either for PRoCon (modified VU Edition) or VeniceRCON.<br>
<b>Why most people would use this mod</b> is because of the `unlockList.*` commands which can be used for managing the loadout. For example if you want to block all explosive weapons you want to use this mod. We also added an unlockList generator file which you can use to generate the commands for RCON and then simply copy and paste to your Startup.txt.<br>
There are also `textChatModeration.*` commands which are mostly known from BFBC2. This allows you to mute players or even promote them. Then you can set the moderation mode to moderated and only promoted players will be able to use the chat.<br><br>
All commands and events are listed below.<br>
BTW this is the first version. If you notice any bugs or have any suggestions feel free to open an issue.

| Command        | Arg1           | Arg2  |Default  |
| ------------- |:-------------:| -----:|-----:|
| admin.forceKillPlayer        | Player      | 
| admin.teamSwitchPlayer       | Player      |
| currentLevel                |
| player.isDead         | Player      | 
| player.isRevivable        | Player      | 
| textChatModerationList.addPlayer                 | admin/voice/muted | Player |
| textChatModerationList.clear        |
| textChatModerationList.list       | 
| textChatModerationList.load       | 
| textChatModerationList.removePlayer        | Player    | 
| textChatModerationList.save       | 
| vars.textChatModerationMode         | free/moderated/muted    |  | free|
| vars.textChatSpamCoolDownTime          | coolDownTime    |  |30 |
| vars.textChatSpamDetectionTime          | detectionTime    |  |6 |
| vars.textChatSpamTriggerCount          | triggerCount    |  |6 |
| vars.unlockMode | all/blacklist/whitelist | | all|
| unlockList.add | weapon/attachment/vehicle	|	
| unlockList.clear| 
| unlockList.list| 
| unlockList.load| 
| unlockList.remove|  weapon/attachment/vehicle/specialization| 
| unlockList.save| 
| unlockList.set | weapons/attachments/vehicles/specializations | 
| vu.Event           | eventName    | false/true |false |

| EventNames        |
| ------------- |
|onLevelLoaded |
|onCapture |
|onCapturePointLost|
|onEngineInit |
|onAuthenticated| 
|onChangingWeapon |
|onChat |
|onCreated| 
|onDestroyed| 
|onEnteredCapturePoint|
|onInstantSuicide |
|onJoining |
|onKickedFromSquad |
|onKilled |
|onKitPickup |
|onLeft |
|onReload| 
|onRespawn| 
|onResupply| 
|onRevive |
|onReviveAccepted |
|onReviveRefused |
|onSetSquad |
|onSetSquadLeader |
|onSpawnAtVehicle |
|onSpawnOnPlayer |
|onSpawnOnSelectedSpawnPoint|
|onSquadChange |
|onSuppressedEnemy |
|onTeamChange |
|onUpdate |
|onUpdateInput |
|onRoundOver |
|onRoundReset |
|onHealthAction| 
|onManDown |
|onPrePhysicsUpdate|
|onDamage |
|onVehicleDestroyed|
|onDisabled |
|onEnter |
|onExit |
|onSpawnDone |
|onUnspawn |
|onEntityFactoryCreated|
|onEntityFactoryCreatedFromBlueprint|
|onFindBestSquad |
|onRequestJoin |
|onSelectTeam |
|onServerSuppressEnemies|
|onSoldierDamage |
