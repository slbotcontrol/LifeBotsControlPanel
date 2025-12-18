// Simple script that returns the Avatars in the region when touched
//
//////// LIFEBOTS COMMAND & CONTROL CODES ////////
integer BOT_SETUP_DEVICENAME        = 280103;   //
integer BOT_SETUP_SETBOT            = 280101;   //
integer SCAN_AVATARS                = 299021;   //
integer BOT_SETUP_SUCCESS           = 280201;   //
integer BOT_SETUP_FAILED            = 280202;   //
integer BOT_RESPONSE                = 300000;   //
//////////////////////////////////////////////////

////////////////////////////////////////////////////
// Get Avatars in the Region
////////////////////////////////////////////////////
string deviceName = "Scan Avatars";
string botName = "Bot Name";
string botCode = "Bot Access Code";
    
default {
    state_entry() {
        // Setup Device
        llMessageLinked(LINK_SET, BOT_SETUP_DEVICENAME, deviceName, llGetOwner());
        
        // Setup Bot
        llMessageLinked(LINK_SET, BOT_SETUP_SETBOT, botName, botCode);
    }
    
    // Scan for Avatars in the region on touch
    touch_start(integer num) {
        llMessageLinked(LINK_SET, SCAN_AVATARS, "", "");
    }
    
    // Notify owner if device was successfully initialized
    // Parse returned JSON object string avatar by avatar to avoid exceeding llSay limit
    link_message( integer sender_num, integer num, string str, key id ) {
        /////////////////// Bot setup success event
        if (num == BOT_SETUP_SUCCESS) {
            // Inform user of successful setup
            llOwnerSay(deviceName + " ready!");
        } else if (num == BOT_SETUP_FAILED) {
            // Inform user of failed setup
            llOwnerSay("ERROR: LifeBots Control Panel setup failed for " + deviceName);
        } else if (num == BOT_RESPONSE) {
            llSay(0, "Avatars in region:");
            string avis = llJsonGetValue(str, ["avatars"]);  
            string avuuid;
            string avinfo;
            string avout;
            list avis_list;
            list json_list;
            integer i;
            integer j;

            // Convert the JSON object string to an LSL strided list
            json_list = llJson2List(avis);

            // Loop through the list, incrementing by 2 in each step
            // Each pair consists of a key and a value, the Avatar UUID and Avatar Info
            for (i = 0; i < llGetListLength(json_list); i += 2)
            {
                avuuid = llList2String(json_list, i);     // This should be the Avatar UUID
                avinfo = llList2String(json_list, i + 1); // This should be the Avatar details
                avout = "\n";
                avis_list = llJson2List(avinfo);
                for (j = 0; j < llGetListLength(avis_list); j += 2)
                {
                    avuuid = llList2String(avis_list, j);
                    avinfo = llList2String(avis_list, j + 1);
                    avout = avout + avuuid + ": " + avinfo + "\n";
                }
                llSay(0, avout);
            }
        }
    }
}
