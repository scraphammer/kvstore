//=============================================================================
// EventInstigatorFunger: Internal developer class for testing.
// Tries to find a PlayerPawn other than the event instigator and fires its event with the other player as the instigator.
// This is probably not useful to most mappers. If there is only one of such pawn it fires an alternate event.
//=============================================================================
class EventInstigatorFunger extends Triggers nousercreate;

//** Tries to find a PlayerPawn other than the event instigator and fires its event with the other player as the instigator. This is probably not useful to most mappers. If there is only one of such pawn it fires an alternate event. */

var(Events) name eventOnlyOnePawn;

function trigger(Actor other, Pawn eventInstigator) {
  local PlayerPawn p;

  if (instigator != none) {
    triggerEvent(event, self, instigator);
    return;
  }
  
  foreach allactors(class'PlayerPawn', p) {
    if (p != eventInstigator) {
      triggerEvent(event, self, p);
      return;
    }
  }

  triggerEvent(eventOnlyOnePawn, self, eventInstigator);
}