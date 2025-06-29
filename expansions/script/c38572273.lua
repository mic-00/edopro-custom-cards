--[[
  38572273 Junior Developer - Davide Chigliaro
--]]
local s,id=GetID()

SET_SENIOR_DEVELOPER = SET_SENIOR_DEVELOPER or 0xffe

function s.initial_effect(c)
  --[[
    If this card is in your hand:
    You can target 1 "Senior Developer" monster in your GY;
    Special Summon it, and if you do, Special Summon this card.
  --]]
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,id)
  e1:SetTarget(s.e1tg)
  e1:SetOperation(s.e1op)
  c:RegisterEffect(e1)
  --[[
    If this card is sent to the GY as material for the
    Synchro Summon of a "SCAI ITEC" monster:
    You can target 1 "Senior Developer" monster in your GY;
    add it to your hand.
  ]]
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id,1))
  e2:SetCategory(CATEGORY_TOHAND + CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCountLimit(1,{id,1})
  e2:SetCondition(s.e2cd)
  e2:SetTarget(s.e2tg)
  e2:SetOperation(s.e2op)
  c:RegisterEffect(e2)
end

s.listed_series = { SET_SENIOR_DEVELOPER }
s.listed_card_types = { TYPE_MONSTER }

s.e1fl = function (c)
  return c:IsSetCard(SET_SENIOR_DEVELOPER) and c:IsMonster()
end
s.e1tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsLocation(LOCATION_GRAVE) and filter(chkc)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
      and Duel.IsExistingTarget(
        function (c) return Duel.IsPlayerCanSpecialSummon(tp, TYPE_SPSUMMON, POS_FACEUP, tp, c) and s.e1fl(c) end,
        tp, LOCATION_GRAVE, 0, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectTarget(tp, s.e1fl, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
  Duel.SetTargetCard(g)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, tp, 0)
end
s.e1op = function (e, tp, eg, ep, ev, re, r, rp)
  local g = Duel.GetTargetCards(e)
  if #g > 0 and Duel.SpecialSummon(g, SUMMON_TYPE_SPECIAL, tp, tp, false, false, POS_FACEUP) ~= 0 then
    Duel.SpecialSummon(e:GetHandler(), SUMMON_TYPE_SPECIAL, tp, tp, false, false, POS_FACEUP)
  end
end

s.e2fl = s.e1fl
s.e2cd = function (e, tp, eg, ep, ev, re, r, rp)
  local c=e:GetHandler()
  return c:IsLocation(LOCATION_GRAVE) and r == REASON_SYNCHRO and c:GetReasonCard():IsSetCard(SET_SCAI_ITEC)
end
s.e2tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsLocation(LOCATION_GRAVE) and filter(chkc)
  end
  if chk == 0 then 
    return Duel.IsExistingTarget(
      function (c) return Duel.IsPlayerCanSendtoHand(tp, c) and s.e2fl(c) end,
      tp, LOCATION_GRAVE, 0, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectTarget(tp, s.e2fl, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
  Duel.SetOperationInfo(0, CATEGORY_TOHAND + CATEGORY_LEAVE_GRAVE, g, 1, tp, 0)
end
s.e2op = function (e, tp, eg, ep, ev, re, r, rp)
  local c = Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) then
    Duel.SendtoHand(c, nil, REASON_EFFECT)
  end
end