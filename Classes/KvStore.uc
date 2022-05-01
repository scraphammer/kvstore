class KvStore extends Inventory nousercreate;

var travel array<string> personalKeys;
var travel array<string> personalValues;
var travel int personalKVLength;

var travel array<string> globalKeys;
var travel array<string> globalValues;
var travel int globalKVLength;

var bool merged;

replication {
  reliable if (Role == ROLE_Authority)
    globalKeys, globalValues, globalKVLength;
}

function destroyed() {
  local KvStore kvs;
  local int i;
  if (!merged) {
    kvs = spawn(class'KvStore');
    for (i = 0; i < globalKVLength; i++) {
      kvs.putSync(globalKeys[i], globalValues[i]);
    }
  }
  super.destroyed();
}

function giveTo(Pawn other) {
  merged = false;
  super.giveTo(other);
}

function merge(KvStore kvs) {
  local int i;
  for (i = 0; i < kvs.globalKVLength; i++) {
    putSync(kvs.globalKeys[i], kvs.globalValues[i]);
  }
  kvs.merged = true;
  kvs.destroy();
}

function bool handlePickupQuery(Inventory item) {
  local KvStore kvs;
  local int i;
	if (item.class == class) {
    kvs = KvStore(item);
    for (i = 0; i < kvs.globalKVLength; i++) {
      putSync(kvs.globalKeys[i], kvs.globalValues[i]);
    }
  }
	return super.handlePickupQuery(item);
}

function bool containsKey(string key, optional bool personal, optional bool ignoreCase) {
  local string value;
  value = get(key, personal, ignoreCase);
  return value != "";
}

function string getCascading(string key, optional bool ignoreCase) {
  local string value;
  value = get(key, true, ignoreCase);
  if (value != "") return value;
  value = get(key, false, ignoreCase);
  return value;
}

function string get(string key, optional bool personal, optional bool ignoreCase) {
  local int i;
  //linear searching is slow here but should be "good enough" in this case.
  //also I do not want to implement hash maps in uscript myself
  if (personal) {
    for (i = 0; i < personalKVLength; i++) {
      if (ignoreCase && caps(personalKeys[i]) == caps(key)) return personalValues[i];
      else if (personalKeys[i] == key) return personalValues[i];
    }
  } else {
    for (i = 0; i < globalKVLength; i++) {
      if (ignoreCase && caps(globalKeys[i]) == caps(key)) return globalValues[i];
      else if (globalKeys[i] == key) return globalValues[i];
    }
  }
  return "";
}

function putSync(string key, coerce string value) {
  local int i;

  if (key == "") return;

  for (i = 0; i < globalKVLength; i++) {
    if (globalKeys[i] == "") {
      globalKeys[i] = key;
      globalValues[i] = value;
      return;
    } else if (globalKeys[i] == key) {
      globalValues[i] = value;
      return;
    }
  }
  globalKeys[globalKVLength] = key;
  globalValues[globalKVLength] = value;
  globalKVLength++;
}

function put(string key, coerce string value, optional bool personal) {
  local int i;
  local KvStore kvs;

  if (key == "") return;

  if (personal) {
    for (i = 0; i < personalKVLength; i++) {
      if (personalKeys[i] == "") {
        personalKeys[i] = key;
        personalValues[i] = value;
        return;
      } else if (personalKeys[i] == key) {
        personalValues[i] = value;
        return;
      }
    }
    personalKeys[personalKVLength] = key;
    personalValues[personalKVLength] = value;
    personalKVLength++;
  } else {
    foreach allactors(class'KvStore', kvs) {
      kvs.putSync(key, value);
    }
  }
}

function bool remove(string key, optional bool personal, optional bool ignoreCase) {
  local int i;
  if (personal) {
    for (i = 0; i < personalKVLength; i++) {
      if (ignoreCase && caps(personalKeys[i]) == caps(key)) {
        personalKeys[i] = "";
        personalValues[i] = "";
        return true;
      } else if (personalKeys[i] == key) {
        personalKeys[i] = "";
        personalValues[i] = "";
        return true;
      }
    }
  } else {
    for (i = 0; i < globalKVLength; i++) {
      if (ignoreCase && caps(globalKeys[i]) == caps(key))  {
        globalKeys[i] = "";
        globalValues[i] = "";
        return true;
      } else if (globalKeys[i] == key) {
        globalKeys[i] = "";
        globalValues[i] = "";
        return true;
      }
    }
  }
  return false;
}

auto state Pickup {
  function tick(float delta) {
    local PlayerPawn p;
    local KvStore kvs;
    foreach allactors(class'PlayerPawn', p) {
      touch(p);
      return;
    }
    foreach allactors(class'KvStore', kvs) {
      if (kvs != self) merge(kvs);
    }
  }
}

defaultproperties {
  bAlwaysRelevant=true
  bDisplayableInv=false
	PickupMessage=""
}