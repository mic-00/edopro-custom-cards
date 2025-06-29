--[[
  39384162 Junior Developer - Michele Masetto
--]]
local s,id=GetID()

SET_SCAI_ITEC        = SET_SCAI_ITEC or 0xffc

function s.initial_effect(c)
  --[[
    If this card is Normal or Special Summoned:
    You can add 1 "SCAI ITEC" Spell/Trap from your Deck to your hand.
  --]]
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
  e1:SetCountLimit(1, id)
  c:RegisterEffect(e1)
	local e2 = e1:Clone()
  e2:SetDescription(aux.Stringid(id,1))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
  --[[
    If this card is sent to the GY as material for the
    Synchro Summon of a "SCAI ITEC" monster:
    You can draw 1 card.
  --]]
  local e3 = Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id,1))
  e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_BE_MATERIAL)
  e3:SetCountLimit(1,{id,1})
  e3:SetCondition(s.e3cd)
  e3:SetTarget(s.e3tg)
  e3:SetOperation(s.e3op)
  c:RegisterEffect(e3)
end

s.listed_series = { SET_SCAI_ITEC }
s.listed_card_types = { TYPE_SPELL, TYPE_TRAP }

s.e1ft = function (c)
  return c:IsSetCard(SET_SCAI_ITEC) and c:IsSpellTrap() and c:IsAbleToHand()
end
s.e1tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(
        function (c) return Duel.IsPlayerCanSendtoHand(tp, c) and s.e1ft(c) end,
        tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND + CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK)
end
s.e1op = function (e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.e1ft, tp, LOCATION_DECK, 0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
  end
end

s.e3cd = function (e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  return c:IsLocation(LOCATION_GRAVE) and r == REASON_SYNCHRO and c:GetReasonCard():IsSetCard(SET_SCAI_ITEC)
end
s.e3tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.IsPlayerCanDraw(tp, num)
  end
  Duel.SetOperationInfo(0, CATEGORY_DRAW, g, 1, tp, 0)
end
s.e3op = function (e, tp, eg, ep, ev, re, r, rp)
  Duel.Draw(tp, 1, REASON_EFFECT)
end
