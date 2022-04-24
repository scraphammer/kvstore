class KvStoreChecker extends Triggers;

#exec texture import file=Textures\ikvcheck.pcx name=i_ikvchecker group=Icons mips=Off flags=2

var() enum CheckType {
  CT_LOCAL_ONLY,
  CT_GLOBAL_ONLY,
  CT_CASCADING,
} checking;

var() enum CheckActionType {
  CA_PRESENT,
  CA_NOT_PRESENT,
  CA_MATCH_VALUE,
  CA_GREATER,
  CA_GREATEREQUAL,
  CA_LESS,
  CA_LESSEQUAL,
} checkAction;

var() bool ignoreCase;
var() localized String keyToCheck;
var() localized String expectedValue;

var(Events) name eventOnCheckFailure;

static final function bool canCoerceBoth(coerce int a, coerce int b) {
  return a != 0 && b != 0;
}

static final operator(24) bool cge (coerce int a, coerce int b) {
  return a >= b;
}

static final operator(24) bool cg (coerce int a, coerce int b) {
  return a > b;
}

static final operator(24) bool cle (coerce int a, coerce int b) {
  return a <= b;
}

static final operator(24) bool cl (coerce int a, coerce int b) {
  return a < b;
}

function trigger(Actor other, Pawn eventInstigator) {
  local Inventory i;
  local KvStore kvs;
  local String value;
  local PlayerPawn p;

  if (checking == CT_LOCAL_ONLY) {
    if (PlayerPawn(eventInstigator) == none) return;
    i = PlayerPawn(eventInstigator).inventory;

    while (i != none) {
      if (KvStore(i) != none) {
        kvs = KvStore(i);
        break;
      }
      i = i.inventory;
    }
  } else {
    foreach allActors(class'PlayerPawn', p) {
      i = p.inventory;
      while (i != none) {
        if (KvStore(i) != none) {
          kvs = KvStore(i);
          break;
        }
        i = i.inventory;
      }
      if (p == eventInstigator && kvs != none) break;
    }
  }

  if (kvs == none) {
    return;
  }

  switch(checking) {
    case CT_LOCAL_ONLY:
      value = kvs.get(keyToCheck, true, ignoreCase);
      break;
    case CT_GLOBAL_ONLY:
      value = kvs.get(keyToCheck, false, ignoreCase);
      break;
    case CT_CASCADING:
      value = kvs.getCascading(keyToCheck, ignoreCase);
      break;
  }

  switch(checkAction) {
    case CA_PRESENT:
      if (value != "" && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value == "" && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      return;
    case CA_NOT_PRESENT:
      if (value != "" && event != '') triggerEvent(eventOnCheckFailure, self, eventInstigator); 
      else if (value == "" && eventOnCheckFailure != '') triggerEvent(event, self, eventInstigator);
      return;
    case CA_MATCH_VALUE:
      if (value == expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value != expectedValue && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      return;
    case CA_GREATER:
      if (canCoerceBoth(value, expectedValue)) {
        if (value cg expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cg expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      } else {
        if (value > expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value > expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      }
      return;
    case CA_GREATEREQUAL:
      if (canCoerceBoth(value, expectedValue)) {
        if (value cge expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cge expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      } else {
        if (value >= expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value >= expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      }
      return;
    case CA_LESS:
      if (canCoerceBoth(value, expectedValue)) {
        if (value cl expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cl expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      } else {
        if (value < expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value < expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      }
      return;
    case CA_LESSEQUAL:
      if (canCoerceBoth(value, expectedValue)) {
        if (value cle expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cle expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      } else {
        if (value <= expectedValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value <= expectedValue) && eventOnCheckFailure != '') triggerEvent(eventOnCheckFailure, self, eventInstigator);
      }
      return;
  }
}

defaultproperties {
  checking=CT_CASCADING
  checkAction=CA_PRESENT
  ignoreCase=true
  texture=Texture'i_ikvchecker'
}