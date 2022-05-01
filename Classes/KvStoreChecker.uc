//=============================================================================
// KvStoreChecker: Checks a key/value pair stored in the player(s) for certain conditions.
// Requires values to be set by KvStoreSetter.
//=============================================================================
class KvStoreChecker extends Triggers;

#exec texture import file=Textures\ikvcheck.pcx name=i_ikvchecker group=Icons mips=Off flags=2

var() enum ECheckScope {
  CS_PERSONAL,
  CS_GLOBAL,
  CS_CASCADING,
} CheckScope;

var() enum ECheckOperation {
  CO_PRESENT,
  CO_NOT_PRESENT,
  CO_EQUAL,
  CO_GREATER,
  CO_GREATEREQUAL,
  CO_LESS,
  CO_LESSEQUAL,
} CheckOperation;

var() bool bIgnoreCase;

var() localized String TargetKey;
var() localized String TargetValue;

var(Events) name EventOnFail;

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

  if (CheckScope == CS_PERSONAL) {
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

  switch(CheckScope) {
    case CS_PERSONAL:
      value = kvs.get(TargetKey, true, bIgnoreCase);
      break;
    case CS_GLOBAL:
      value = kvs.get(TargetKey, false, bIgnoreCase);
      break;
    case CS_CASCADING:
      value = kvs.getCascading(TargetKey, bIgnoreCase);
      break;
  }

  switch(CheckOperation) {
    case CO_PRESENT:
      if (value != "" && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value == "" && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      return;
    case CO_NOT_PRESENT:
      if (value != "" && event != '') triggerEvent(EventOnFail, self, eventInstigator); 
      else if (value == "" && EventOnFail != '') triggerEvent(event, self, eventInstigator);
      return;
    case CO_EQUAL:
      if (value == TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value != TargetValue && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      return;
    case CO_GREATER:
      if (canCoerceBoth(value, TargetValue)) {
        if (value cg TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cg TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      } else {
        if (value > TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value > TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      }
      return;
    case CO_GREATEREQUAL:
      if (canCoerceBoth(value, TargetValue)) {
        if (value cge TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cge TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      } else {
        if (value >= TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value >= TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      }
      return;
    case CO_LESS:
      if (canCoerceBoth(value, TargetValue)) {
        if (value cl TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cl TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      } else {
        if (value < TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value < TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      }
      return;
    case CO_LESSEQUAL:
      if (canCoerceBoth(value, TargetValue)) {
        if (value cle TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value cle TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      } else {
        if (value <= TargetValue && event != '') triggerEvent(event, self, eventInstigator); 
        else if (!(value <= TargetValue) && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      }
      return;
  }
}

defaultproperties {
  CheckScope=CS_GLOBAL
  CheckOperation=CO_EQUAL
  bIgnoreCase=True
  Texture=Texture'i_ikvchecker'
}