// Simple script that returns the Profile Picks of whoever touches the object
// This script performs the same actions as the avatar_picks.lsl script but
// all calls to llJsonGetValue() have been replaced with calls to jsonGetValue()
//
// This example illustrates how to validate the arguments to llJsonGetValue()
// using the jsonGetValue() function defined below.
//
//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer AVATAR_PICKS                = 299024;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_RESPONSE                = 300000;   //
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// Get Avatar Picks, Validate llJsonGetValue() calls
////////////////////////////////////////////////////
string deviceName = "Avatar Picks with Validation";
string botName = "Bot Name";
string botCode = "Bot Access Code";
key touchUUID = NULL_KEY;

// JSON_TYPE integers
integer invalid = 1;   // invalid
integer null    = 32;  // null

// map the json type to a useful bitmask
integer jsonType(string json, list specifiers) {
    return llRound(llPow(2.,(float)((integer)llGetSubString(
        llEscapeURL(llJsonValueType(json,specifiers)),8,8))));
}

// as long as it is not null or invalid, returns true
integer jsonValid(string value, list spec) {
    return (
        !(jsonType(value,spec) & (invalid | null))
    );
}

string jsonGetValue(string json, list spec) {
    if(jsonValid(json,spec)) return llJsonGetValue(json,spec);
    else return "";
}
    
default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }
    
    // Get avatar profile picks on touch
    touch_start(integer num) {
        touchUUID = llDetectedKey(0);
        llMessageLinked(LINK_SET, AVATAR_PICKS, "", touchUUID);
    }
    
    // Notify owner if device was successfully initialized
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if (num == BOT_SETUP_SUCCESS) {
            // Inform user of successful setup
            llOwnerSay(deviceName + " ready!");
        } else if (num == BOT_SETUP_FAILED) {
            // Inform user of failed setup
            llOwnerSay("ERROR: LifeBots Control Panel setup failed for " + deviceName);
        } else if (num == BOT_RESPONSE) {
            string displayName = llGetDisplayName(touchUUID);
            llSay(0, displayName + " profile picks:\n" + jsonGetValue(str, ["picks"]));
        }
    }
}
