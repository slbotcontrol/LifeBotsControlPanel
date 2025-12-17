// Simple script that invites whoever touches the object to the specified group
//
// Sets up the device and the bot in state_entry
// Sends out group invite on touch
//
///////// LIFEBOTS COMMAND & CONTROL ////////////////
//                                                 //
// Setup and startup                               //
integer BOT_SETUP_SETBOT            = 280101;      //
// Device Settings                                 //
integer BOT_SETUP_DEVICENAME        = 280103;      //
// Group Management                                //
integer BOT_GROUP_INVITE            = 280156;      //
// EVENTS                                          //
integer BOT_SETUP_SUCCESS           = 280201;      //
/////////////////////////////////////////////////////

////////////////////////////////////////////////////
// Land Inviter
////////////////////////////////////////////////////
string deviceName = "Inviter";
string botName = "Bot Name";
string botCode = "Bot Access Code";
string groupID = "UUID of group you want the bot to invite to";
string roleID = "UUID of role you want the bot to invite to"; //NULL_KEY for everyone
    
default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }
    
    // Send out group invite on touch
    touch_start(integer num) {
        llMessageLinked(LINK_SET, BOT_GROUP_INVITE, groupID + "\n" + roleID, llDetectedKey(0));
    }
    
    // Notify owner if device was successfully initialized
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if(num==BOT_SETUP_SUCCESS) {
            // Inform user
            llOwnerSay(deviceName + " ready!");
        }
    }
}
