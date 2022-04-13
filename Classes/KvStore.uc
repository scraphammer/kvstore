class KvStore extends Inventory nousercreate;

var travel array<string> localKeys;
var travel array<string> localValues;
var travel int localKVLength;

var travel array<string> globalKeys;
var travel array<string> globalValues;
var travel int globalKVLength;

replication {
  reliable if (Role == ROLE_Authority)
    globalKeys, globalValues, globalKVLength;
}

function bool containsKey(string key, optional bool local, optional bool ignoreCase) {
  local string value;
  value = get(key, local, ignoreCase);
  return value != "";
}

function string getCascading(string key, optional bool ignoreCase) {
  local string value;
  value = get(key, true, ignoreCase);
  if (value != "") return value;
  value = get(key, false, ignoreCase);
  return value;
}

function string get(string key, optional bool local, optional bool ignoreCase) {
  local int i;
  //linear searching is slow here but should be "good enough" in this case.
  //also I do not want to implement hash maps in uscript myself
  if (local) {
    for (i = 0; i < localKVLength; i++) {
      if (ignoreCase && caps(localKeys[i]) == caps(key)) return localValues[i];
      else if (localKeys[i] == key) return localValues[i];
    }
  } else {
    for (i = 0; i < globalKVLength; i++) {
      if (ignoreCase && caps(globalKeys[i]) == caps(key)) return globalValues[i];
      else if (globalKeys[i] == key) return globalValues[i];
    }
  }
  return "";
}

function put(string key, coerce string value, optional bool local) {
  local int i;
  if (local) {
    for (i = 0; i < localKVLength; i++) {
      if (localKeys[i] == "") {
        localKeys[i] = key;
        localValues[i] = value;
        return;
      }
    }
    localKeys[localKVLength++] = key;
    localValues[localKVLength] = value;
  } else {
    for (i = 0; i < globalKVLength; i++) {
      if (globalKeys[i] == "") {
        globalKeys[i] = key;
        globalValues[i] = value;
        return;
      }
    }
    globalKeys[globalKVLength++] = key;
    globalValues[globalKVLength] = value;
  }
}

function bool remove(string key, optional bool local, optional bool ignoreCase) {
  local int i;
  if (local) {
    for (i = 0; i < localKVLength; i++) {
      if (ignoreCase && caps(localKeys[i]) == caps(key)) {
        localKeys[i] = "";
        localValues[i] = "";
        return true;
      } else if (localKeys[i] == key) {
        localKeys[i] = "";
        localValues[i] = "";
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

defaultproperties {
  
}