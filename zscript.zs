// SPDX-FileCopyrightText: 2021 Alexander Kromm <mmaulwurff@gmail.com>
//
// SPDX-License-Identifier: MIT

version 4.5

class cc_EventHandler : EventHandler
{

  override bool inputProcess(InputEvent event)
  {
    string aClass = "DoomImp2";
    if (players[consolePlayer].mo.getClass() == aClass) console.printf("how");

    // Ignore input events that are not key press.
    if (event.type != InputEvent.Type_KeyDown)
    {
      return false;
    }

    // Too much time since last input - discard everything that was previously typed.
    int timeSinceLastPress = Level.time - mLastPressTime;
    if (timeSinceLastPress > STALE_INPUT_THRESHOLD)
    {
      resetInput();
    }

    // Remember input and when it was taken.
    mLastPressTime = Level.time;
    mInput.appendFormat("%c", event.keyChar);

    // When something is already typed, do not enter chat.
    bool shouldInputBeIgnored = (mInput.length() > 1)
      && (isKeyForCommand(event.keyScan, "messagemode")
       || isKeyForCommand(event.keyScan, "messagemode2"));

    // Check if input matches our custom cheat codes.
    //
    // As we cannot change gameplay directly in this function (it is UI-scoped),
    // we have to pass events through network code. The receiving end is in
    // networkProcess function.
    if      (mInput == "givesoul") sendCheat("cc_givesoul");
    else if (mInput == "shotg")    sendCheat("cc_shotg");

    return shouldInputBeIgnored;
  }

  override void networkProcess(ConsoleEvent event)
  {
    // get player who did cheat input.
    let player = players[event.player].mo;
    if (player == NULL) return;

    // Check if network event matches our cheat code events.
    //
    // Remember that this function catches all network events, including not
    // related to our custom cheat codes, so we have to react only on our
    // commands.
    if (event.name == "cc_givesoul")
    {
      // Spawn a soulsphere where player stands, player automatically picks it up.
      console.printf("Soulsphere cheat code activated!");
      Actor.spawn("Soulsphere", player.pos);
    }
    else if (event.name == "cc_shotg")
    {
      // Give the player a shotgun and select it.
      console.printf("Shotgun cheat code activated!");
      player.giveInventory("Shotgun", 1);
      player.player.pendingWeapon = Weapon(player.findInventory("Shotgun"));
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private ui void sendCheat(string cheat)
  {
    sendNetworkEvent(cheat);
    resetInput();
  }

  private ui void resetInput() { mInput = ""; }

  private static ui
  bool isKeyForCommand(int key, string command)
  {
    Array<int> keys;
    bindings.getAllKeysForCommand(keys, command);
    uint nKeys = keys.size();
    for (uint i = 0; i < nKeys; ++i)
    {
      if (keys[i] == key) return true;
    }
    return false;
  }

  const STALE_INPUT_THRESHOLD = 35;

  private ui int    mLastPressTime;
  private ui string mInput;

}
