//=============================================================================
// KvStoreChecker: Checks a key/value pair stored in the player(s) for certain conditions.
// Requires values to be set by KvStoreSetter.
//=============================================================================
class KvStoreChecker extends Triggers;

#exec texture import file=Textures\ikvcheck.pcx name=i_ikvchecker group=Icons mips=Off flags=2

var(KvStore) enum ECheckScope {
  CS_PERSONAL,
  CS_GLOBAL,
  CS_CASCADING,
} CheckScope;

var(KvStore) enum ECheckOperation {
  CO_PRESENT,
  CO_NOT_PRESENT,
  CO_EQUAL,
  CO_GREATER,
  CO_GREATEREQUAL,
  CO_LESS,
  CO_LESSEQUAL,
} CheckOperation;

var(KvStore) bool bIgnoreCase;

var(KvStore) localized String TargetKey;
var(KvStore) localized String TargetValue;

var(Events) bool bTriggerImmediately;

var(Events) name EventOnFail;

var Color failLineColor;
var Color drawImmediatelyColor;

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

function tick(float delta) {
  local Inventory i;
  local KvStore kvs;
  local PlayerPawn p;

  if (bTriggerImmediately) {
    foreach allActors(class'PlayerPawn', p) {
      i = p.inventory;
      while (i != none) {
        if (KvStore(i) != none) {
          kvs = KvStore(i);
          break;
        }
        i = i.inventory;
      }
      if (kvs != none) {
        trigger(self, p);
        bTriggerImmediately = false;
        return;
      }
    }
  }
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

    if (kvs == none) {
      kvs = spawn(class'KvStore');
      kvs.touch(p);
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

      if (kvs == none) {
        kvs = spawn(class'KvStore');
        kvs.touch(p);
      }
      if (p == eventInstigator && kvs != none) break;
    }
  }

  if (kvs == none) {
    return;
  }

  switch(CheckScope) {
    case CS_PERSONAL:
      value = kvs.get(targetKey, true, bIgnoreCase);
      break;
    case CS_GLOBAL:
      value = kvs.get(targetKey, false, bIgnoreCase);
      break;
    case CS_CASCADING:
      value = kvs.getCascading(targetKey, bIgnoreCase);
      break;
  }

  switch(CheckOperation) {
    case CO_PRESENT:
      if (value != "" && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value == "" && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
      return;
    case CO_NOT_PRESENT:
      if (value == "" && event != '') triggerEvent(event, self, eventInstigator); 
      else if (value != "" && EventOnFail != '') triggerEvent(EventOnFail, self, eventInstigator);
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

event drawEditorSelection(Canvas canvas) {
  local Actor a;
  local vector w2s;
  local float z;

  if (bTriggerImmediately) {
    canvas.drawColor = drawImmediatelyColor;
    canvas.drawCircle(drawImmediatelyColor, 0, location - vect(8, 8, 8), 2);
    canvas.drawCircle(drawImmediatelyColor, 0, location - vect(8, 8, 8), 1);
    canvas.font = Font'Engine.SmallFont';
    w2s = canvas.worldToScreen(location - vect(12, 8, 8), z);
    canvas.CurX = w2s.x;
    canvas.CurY = w2s.y;
    canvas.drawText("bTriggerImmediately");
  }

  if (eventOnFail == '') return;

  canvas.drawColor = failLineColor;
  foreach allActors(class'Actor', a, eventOnFail) {
    canvas.draw3dline(canvas.drawColor, location, a.location);
  }
}

defaultproperties {
  CheckScope=CS_GLOBAL
  CheckOperation=CO_EQUAL
  bIgnoreCase=True
  Texture=Texture'i_ikvchecker'
	bEditorSelectRender=True
  failLineColor=(R=255,G=85,B=0)
  drawImmediatelyColor=(R=255,G=0,B=0)
}